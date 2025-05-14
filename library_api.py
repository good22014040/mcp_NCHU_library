import requests
import urllib.parse
import time
import re
from mcp.server.fastmcp import FastMCP


mcp = FastMCP("NCHU_library")

@mcp.tool()
def search_nchu_library_books(query: str):
    """
    Search books from the NCHU (National Chung Hsing University) Library using the Primo API.

    Args:
        query (str): The keyword to search for (supports Chinese characters).

    Returns:
        List[dict]: A list of dictionaries, each containing:
            - 'title': The book title (with metadata cleaned).
            - 'creator': The main creator or contributor (with $$Q metadata removed).
            - 'publisher': The name of the publishing organization.
            - 'year': The year the book was published (extracted from date).
            - 'isbn': The primary ISBN of the book.
            - If a request fails, a dictionary with 'error' and 'offset' keys is returned instead.

    """
    total_count: int = 10 
    page_size: int = 10


    base_url = "https://nchu.primo.exlibrisgroup.com/primaws/rest/pub/pnxs"
    encoded_query = urllib.parse.quote(query)
    results = []

    for offset in range(0, total_count, page_size):
        url = (
            f"{base_url}?acTriggered=false&blendFacetsSeparately=false"
            f"&came_from=pagination_1_2&citationTrailFilterByAvailability=true"
            f"&disableCache=false&getMore=0&inst=886NCHU_INST&isCDSearch=false"
            f"&lang=zh-tw&limit={page_size}&newspapersActive=false&newspapersSearch=false"
            f"&offset={offset}&otbRanking=false&pcAvailability=false"
            f"&q=any,contains,{encoded_query}&qExclude=&qInclude="
            f"&rapido=false&refEntryActive=false&rtaLinks=true"
            f"&scope=MyInst_and_CI&searchInFulltextUserSelection=false"
            f"&skipDelivery=Y&sort=rank&tab=Everything&vid=886NCHU_INST:886NCHU_INST"
        )

        try:
            response = requests.get(url)
            response.raise_for_status()
            data = response.json()
            for doc in data.get("docs", []):
                display = doc.get("pnx", {}).get("display", {})
                addata = doc.get("pnx", {}).get("addata", {})

                # Clean helpers
                def clean_value(val_list):
                    if not val_list:
                        return ""
                    val = val_list[0]
                    return re.sub(r"\$\$Q.*", "", val).strip()

                title = clean_value(display.get("title"))
                creator = clean_value(display.get("creator") or display.get("contributor"))
                publisher = clean_value(display.get("publisher") or addata.get("pub"))
                year = ""
                date_list = display.get("creationdate") or addata.get("date")
                if date_list:
                    year_match = re.search(r"\d{4}", date_list[0])
                    if year_match:
                        year = year_match.group(0)
                isbn = ""
                isbn_list = addata.get("isbn")
                if isbn_list:
                    isbn = re.sub(r"[^\dXx]", "", isbn_list[0].split()[0])

                results.append({
                    "title": title,
                    "creator": creator,
                    "publisher": publisher,
                    "year": year,
                    "isbn": isbn
                })

            time.sleep(1)  # 防止被封鎖
        except Exception as e:
            results.append({"error": str(e), "offset": offset})

    return results

if __name__ == "__main__":
    # Initialize and run the server
    mcp.run(transport='stdio')