"""
Mapping from this project's ministry_id to egazette.gov.in's own
`ddlMinistry` search dropdown value(s), built 2026-09-06 by fetching the
live dropdown via `ingest.egazette_search.list_ministries()` (606 entries)
and matching by ministry name against this project's own ministry table,
after collapsing repeated whitespace (the official list has at least one
entry with a double space, "Ministry of Environment,  Forest  and Climate
Change", that a naive exact match misses).

52 of 53 matched this way with no fuzzy guessing. The one exception,
`atomic-energy` ("Department of Atomic Energy" in this project's own
ministry table), has no exact-or-whitespace-normalized match in the
dropdown; two related official entries exist instead --
'Ministry of Atomic Energy' (375) and 'PMO --> Department of Atomic
Energy' (157, HTML-escaped as 'PMO --&gt; Department of Atomic Energy' in
the raw option text -- India's Department of Atomic Energy sits directly
under the PMO, matching this project's own stored name) -- both are listed
so a search merges results from either name a notification might carry.

Used by `ingest/freshness_check.py` to know which egazette.gov.in ministry
value(s) to query via `ingest.egazette_search.search_by_ministry_since()`
for each already-modeled ministry, as a second source alongside
gazettetracker.com (`db/tracker_slugs.py`'s MINISTRY_TRACKER_SLUGS).
"""

EGAZETTE_MINISTRY_VALUES = {
    'agriculture-and-farmers-welfare': ['5'],  # Ministry of Agriculture and Farmers Welfare
    'atomic-energy': ['375', '157'],  # Ministry of Atomic Energy / PMO --> Department of Atomic Energy
    'ayush': ['372'],  # Ministry of Ayush
    'chemicals-and-fertilizers': ['6'],  # Ministry of Chemicals and Fertilizers
    'civil-aviation': ['7'],  # Ministry of Civil Aviation
    'coal': ['8'],  # Ministry of Coal
    'commerce-and-industry': ['9'],  # Ministry of Commerce and Industry
    'communications': ['294'],  # Ministry of Communications
    'consumer-affairs-food-public-distribution': ['30'],  # Ministry of Consumer Affairs, Food and Public Distribution
    'cooperation': ['558'],  # Ministry of Cooperation
    'corporate-affairs': ['19'],  # Ministry of Corporate Affairs
    'culture': ['31'],  # Ministry of Culture
    'defence': ['4'],  # Ministry of Defence
    'department-of-space': ['71'],  # Department of Space
    'doner': ['67'],  # Ministry of Development of North Eastern Region
    'earth-sciences': ['91'],  # Ministry of Earth Sciences
    'education': ['296'],  # Ministry of Education
    'electronics-and-information-technology': ['397'],  # Ministry of Electronics and Information Technology
    'environment-forest-climate-change': ['378'],  # Ministry of Environment, Forest and Climate Change
    'external-affairs': ['58'],  # Ministry of External Affairs
    'finance-other-departments': ['18'],  # Ministry of Finance
    'finance-revenue-cbic': ['18'],  # Ministry of Finance
    'fisheries-animal-husbandry-dairying': ['442'],  # Ministry of Fisheries, Animal Husbandry and Dairying
    'food-processing-industries': ['32'],  # Ministry of Food Processing Industries
    'health-family-welfare': ['27'],  # Ministry of Health and Family Welfare
    'heavy-industries': ['70'],  # Ministry of Heavy Industries
    'home-affairs': ['13'],  # Ministry of Home Affairs
    'housing-and-urban-affairs': ['1'],  # Ministry of Housing and Urban Affairs
    'information-and-broadcasting': ['52'],  # Ministry of Information and Broadcasting
    'jal-shakti': ['444'],  # Ministry of Jal Shakti
    'labour-and-employment': ['28'],  # Ministry of Labour and Employment
    'mines': ['86'],  # Ministry of Mines
    'minority-affairs': ['29'],  # Ministry of Minority Affairs
    'msme': ['68'],  # Ministry of Micro, Small and Medium Enterprises
    'new-and-renewable-energy': ['141'],  # Ministry of New and Renewable Energy
    'parliamentary-affairs': ['107'],  # Ministry of Parliamentary Affairs
    'personnel-public-grievances-pensions': ['26'],  # Ministry of Personnel, Public Grievances and Pensions
    'petroleum-and-natural-gas': ['12'],  # Ministry of Petroleum and Natural Gas
    'ports-shipping-waterways': ['132'],  # Ministry of Ports, Shipping and Waterways
    'posts': ['294'],  # Ministry of Communications
    'power': ['55'],  # Ministry of Power
    'railways': ['33'],  # Ministry of Railways
    'road-transport-highways': ['133'],  # Ministry of Road Transport and Highways
    'rural-development': ['51'],  # Ministry of Rural Development
    'science-and-technology': ['43'],  # Ministry of Science and Technology
    'skill-development-entrepreneurship': ['371'],  # Ministry of Skill Development and Entrepreneurship
    'social-justice-and-empowerment': ['61'],  # Ministry of Social Justice and Empowerment
    'statistics-and-programme-implementation': ['90'],  # Ministry of Statistics and Programme Implementation
    'steel': ['34'],  # Ministry of Steel
    'textiles': ['14'],  # Ministry of Textiles
    'tribal-affairs': ['69'],  # Ministry of Tribal Affairs
    'women-child-development': ['50'],  # Ministry of Women and Child Development
    'youth-affairs-and-sports': ['92'],  # Ministry of Youth Affairs and Sports
}
