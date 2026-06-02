// Standalone Context7 extension — zero external imports.
// API logic adapted from @upstash/context7-pi (MIT) with typebox schemas
// replaced by plain JSON Schema to avoid Bun-compiled-binary incompatibility.

const BASE_URL = "https://context7.com/api";

function authHeaders(): Record<string, string> {
  const apiKey = process.env.CONTEXT7_API_KEY;
  return apiKey ? { Authorization: `Bearer ${apiKey}` } : {};
}

async function parseErrorResponse(response: Response): Promise<string> {
  try {
    const json = (await response.json()) as { message?: string };
    if (json.message) return json.message;
  } catch {
    // JSON parsing failed, fall through to status-based message
  }

  const hasKey = Boolean(process.env.CONTEXT7_API_KEY);
  if (response.status === 429) {
    return hasKey
      ? "Rate limited or quota exceeded. Upgrade your plan at https://context7.com/plans for higher limits."
      : "Rate limited or quota exceeded. Create a free API key at https://context7.com/dashboard for higher limits.";
  }
  if (response.status === 404) {
    return "The library you are trying to access does not exist. Please try with a different library ID.";
  }
  if (response.status === 401) {
    return "Invalid API key. Please check your API key. API keys should start with 'ctx7sk' prefix.";
  }
  return `Request failed with status ${response.status}. Please try again later.`;
}

interface SearchResult {
  id: string;
  title: string;
  description: string;
  branch: string;
  lastUpdateDate: string;
  state: string;
  totalTokens: number;
  totalSnippets: number;
  stars?: number;
  trustScore?: number;
  benchmarkScore?: number;
  versions?: string[];
  source?: string;
}

interface SearchResponse {
  error?: string;
  results: SearchResult[];
  searchFilterApplied?: boolean;
}

async function searchLibraries(
  query: string,
  libraryName: string,
): Promise<SearchResponse> {
  const url = new URL(`${BASE_URL}/v2/libs/search`);
  url.searchParams.set("query", query);
  url.searchParams.set("libraryName", libraryName);

  const response = await fetch(url, { headers: authHeaders() });
  if (!response.ok) {
    return { results: [], error: await parseErrorResponse(response) };
  }
  return (await response.json()) as SearchResponse;
}

async function fetchLibraryContext(
  query: string,
  libraryId: string,
): Promise<string> {
  const url = new URL(`${BASE_URL}/v2/context`);
  url.searchParams.set("query", query);
  url.searchParams.set("libraryId", libraryId);

  const response = await fetch(url, { headers: authHeaders() });
  if (!response.ok) {
    return parseErrorResponse(response);
  }

  const text = await response.text();
  if (!text) {
    return "Documentation not found or not finalized for this library. This might have happened because you used an invalid Context7-compatible library ID. To get a valid Context7-compatible library ID, use the 'resolve-library-id' with the package name you wish to retrieve documentation for.";
  }
  return text;
}

function getSourceReputationLabel(
  sourceReputation?: number,
): "High" | "Medium" | "Low" | "Unknown" {
  if (sourceReputation === undefined || sourceReputation < 0) return "Unknown";
  if (sourceReputation >= 7) return "High";
  if (sourceReputation >= 4) return "Medium";
  return "Low";
}

function formatSearchResult(result: SearchResult): string {
  const lines = [
    `- Title: ${result.title}`,
    `- Context7-compatible library ID: ${result.id}`,
    `- Description: ${result.description}`,
  ];

  if (result.totalSnippets !== -1 && result.totalSnippets !== undefined) {
    lines.push(`- Code Snippets: ${result.totalSnippets}`);
  }

  const reputationLabel = getSourceReputationLabel(result.trustScore);
  lines.push(`- Source Reputation: ${reputationLabel}`);

  if (result.benchmarkScore !== undefined && result.benchmarkScore > 0) {
    lines.push(`- Benchmark Score: ${result.benchmarkScore}`);
  }

  if (result.versions !== undefined && result.versions.length > 0) {
    lines.push(`- Versions: ${result.versions.join(", ")}`);
  }

  if (result.source) {
    lines.push(`- Source: ${result.source}`);
  }

  return lines.join("\n");
}

function formatSearchResults(searchResponse: SearchResponse): string {
  if (!searchResponse.results || searchResponse.results.length === 0) {
    return "No documentation libraries found matching your query.";
  }

  const parts: string[] = [];

  if (searchResponse.searchFilterApplied) {
    parts.push(
      "**Note:** Your results only include libraries matching your teamspace's library filters. To adjust quality thresholds or blocked libraries, update your filters at https://context7.com/dashboard?tab=policies",
    );
  }

  const formattedResults = searchResponse.results.map(formatSearchResult);
  parts.push(formattedResults.join("\n----------\n"));

  return parts.join("\n\n");
}

function toToolResult(text: string) {
  return {
    content: [{ type: "text" as const, text }],
    details: undefined,
  };
}

export default function (pi: any) {
  pi.registerTool({
    name: "resolve-library-id",
    label: "Resolve Context7 Library ID",
    description: `Resolves a package/product name to a Context7-compatible library ID and returns matching libraries.

You MUST call this function before 'Query Documentation' tool to obtain a valid Context7-compatible library ID UNLESS the user explicitly provides a library ID in the format '/org/project' or '/org/project/version' in their query.

Each result includes:
- Library ID: Context7-compatible identifier (format: /org/project)
- Name: Library or package name
- Description: Short summary
- Code Snippets: Number of available code examples
- Source Reputation: Authority indicator (High, Medium, Low, or Unknown)
- Benchmark Score: Quality indicator (100 is the highest score)
- Versions: List of versions if available. Use one of those versions if the user provides a version in their query. The format of the version is /org/project/version.

For best results, select libraries based on name match, source reputation, snippet coverage, benchmark score, and relevance to your use case.

Selection Process:
1. Analyze the query to understand what library/package the user is looking for
2. Return the most relevant match based on:
- Name similarity to the query (exact matches prioritized)
- Description relevance to the query's intent
- Documentation coverage (prioritize libraries with higher Code Snippet counts)
- Source reputation (consider libraries with High or Medium reputation more authoritative)
- Benchmark Score: Quality indicator (100 is the highest score)

Response Format:
- Return the selected library ID in a clearly marked section
- Provide a brief explanation for why this library was chosen
- If multiple good matches exist, acknowledge this but proceed with the most relevant one
- If no good matches exist, clearly state this and suggest query refinements

For ambiguous queries, request clarification before proceeding with a best-guess match.

IMPORTANT: Do not call this tool more than 3 times per question. If you cannot find what you need after 3 calls, use the best result you have.`,
    parameters: {
      type: "object",
      properties: {
        query: {
          type: "string",
          description:
            "The question or task you need help with. This is used to rank library results by relevance to what the user is trying to accomplish. The query is sent to the Context7 API for processing. Do not include any sensitive or confidential information such as API keys, passwords, credentials, personal data, or proprietary code in your query.",
        },
        libraryName: {
          type: "string",
          description:
            "Library name to search for and retrieve a Context7-compatible library ID. Use the official library name with proper punctuation — e.g., 'Next.js' instead of 'nextjs', 'Customer.io' instead of 'customerio', 'Three.js' instead of 'threejs'.",
        },
      },
      required: ["query", "libraryName"],
    },
    async execute(
      _toolCallId: string,
      params: { query: string; libraryName: string },
    ) {
      const searchResponse = await searchLibraries(
        params.query,
        params.libraryName,
      );
      if (!searchResponse.results || searchResponse.results.length === 0) {
        return toToolResult(
          searchResponse.error ??
            "No libraries found matching the provided name.",
        );
      }
      return toToolResult(
        `Available Libraries:\n\n${formatSearchResults(searchResponse)}`,
      );
    },
  });

  pi.registerTool({
    name: "query-docs",
    label: "Query Documentation",
    description: `Retrieves and queries up-to-date documentation and code examples from Context7 for any programming library or framework.

You must call 'Resolve Context7 Library ID' tool first to obtain the exact Context7-compatible library ID required to use this tool, UNLESS the user explicitly provides a library ID in the format '/org/project' or '/org/project/version' in their query.

Do not call this tool more than 3 times per question.`,
    parameters: {
      type: "object",
      properties: {
        libraryId: {
          type: "string",
          description:
            "Exact Context7-compatible library ID (e.g., '/mongodb/docs', '/vercel/next.js', '/supabase/supabase', '/vercel/next.js/v14.3.0-canary.87') retrieved from 'resolve-library-id' or directly from user query in the format '/org/project' or '/org/project/version'.",
        },
        query: {
          type: "string",
          description:
            "The question or task you need help with. Be specific and include relevant details. Good: 'How to set up authentication with JWT in Express.js' or 'React useEffect cleanup function examples'. Bad: 'auth' or 'hooks'. The query is sent to the Context7 API for processing. Do not include any sensitive or confidential information such as API keys, passwords, credentials, personal data, or proprietary code in your query.",
        },
      },
      required: ["libraryId", "query"],
    },
    async execute(
      _toolCallId: string,
      params: { libraryId: string; query: string },
    ) {
      const text = await fetchLibraryContext(params.query, params.libraryId);
      return toToolResult(text);
    },
  });
}
