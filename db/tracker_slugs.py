"""
Mapping from this project's ministry_id to gazettetracker.com's slug,
built 2026-09-05 by fetching gazettetracker.com/ministries (299 listed) and
matching by exact ministry name against this project's own ministry table
-- all 53 matched exactly, no fuzzy guessing. Used by ingest/freshness_check.py
to know which tracker listing page to poll for each already-modeled ministry.
"""

MINISTRY_TRACKER_SLUGS = {
    'agriculture-and-farmers-welfare': 'ministry-of-agriculture-and-farmers-welfare',  # Ministry of Agriculture and Farmers Welfare
    'atomic-energy': 'department-of-atomic-energy',  # Department of Atomic Energy
    'ayush': 'ministry-of-ayush',  # Ministry of Ayush
    'chemicals-and-fertilizers': 'ministry-of-chemicals-and-fertilizers',  # Ministry of Chemicals and Fertilizers
    'civil-aviation': 'ministry-of-civil-aviation',  # Ministry of Civil Aviation
    'coal': 'ministry-of-coal',  # Ministry of Coal
    'commerce-and-industry': 'ministry-of-commerce-and-industry',  # Ministry of Commerce and Industry
    'communications': 'ministry-of-communications',  # Ministry of Communications
    'consumer-affairs-food-public-distribution': 'ministry-of-consumer-affairs-food-and-public-distribution',  # Ministry of Consumer Affairs, Food and Public Distribution
    'cooperation': 'ministry-of-cooperation',  # Ministry of Cooperation
    'corporate-affairs': 'ministry-of-corporate-affairs',  # Ministry of Corporate Affairs
    'culture': 'ministry-of-culture',  # Ministry of Culture
    'defence': 'ministry-of-defence',  # Ministry of Defence
    'department-of-space': 'department-of-space',  # Department of Space
    'doner': 'ministry-of-development-of-north-eastern-region',  # Ministry of Development of North Eastern Region
    'earth-sciences': 'ministry-of-earth-sciences',  # Ministry of Earth Sciences
    'education': 'ministry-of-education',  # Ministry of Education
    'electronics-and-information-technology': 'ministry-of-electronics-and-information-technology',  # Ministry of Electronics and Information Technology
    'environment-forest-climate-change': 'ministry-of-environment-forest-and-climate-change',  # Ministry of Environment, Forest and Climate Change
    'external-affairs': 'ministry-of-external-affairs',  # Ministry of External Affairs
    'finance-other-departments': 'ministry-of-finance',  # Ministry of Finance
    'finance-revenue-cbic': 'ministry-of-finance',  # Ministry of Finance
    'fisheries-animal-husbandry-dairying': 'ministry-of-fisheries-animal-husbandry-and-dairying',  # Ministry of Fisheries, Animal Husbandry and Dairying
    'food-processing-industries': 'ministry-of-food-processing-industries',  # Ministry of Food Processing Industries
    'health-family-welfare': 'ministry-of-health-and-family-welfare',  # Ministry of Health and Family Welfare
    'heavy-industries': 'ministry-of-heavy-industries',  # Ministry of Heavy Industries
    'home-affairs': 'ministry-of-home-affairs',  # Ministry of Home Affairs
    'housing-and-urban-affairs': 'ministry-of-housing-and-urban-affairs',  # Ministry of Housing and Urban Affairs
    'information-and-broadcasting': 'ministry-of-information-and-broadcasting',  # Ministry of Information and Broadcasting
    'jal-shakti': 'ministry-of-jal-shakti',  # Ministry of Jal Shakti
    'labour-and-employment': 'ministry-of-labour-and-employment',  # Ministry of Labour and Employment
    'mines': 'ministry-of-mines',  # Ministry of Mines
    'minority-affairs': 'ministry-of-minority-affairs',  # Ministry of Minority Affairs
    'msme': 'ministry-of-micro-small-and-medium-enterprises',  # Ministry of Micro, Small and Medium Enterprises
    'new-and-renewable-energy': 'ministry-of-new-and-renewable-energy',  # Ministry of New and Renewable Energy
    'parliamentary-affairs': 'ministry-of-parliamentary-affairs',  # Ministry of Parliamentary Affairs
    'personnel-public-grievances-pensions': 'ministry-of-personnel-public-grievances-and-pensions',  # Ministry of Personnel, Public Grievances and Pensions
    'petroleum-and-natural-gas': 'ministry-of-petroleum-and-natural-gas',  # Ministry of Petroleum and Natural Gas
    'ports-shipping-waterways': 'ministry-of-ports-shipping-and-waterways',  # Ministry of Ports, Shipping and Waterways
    'posts': 'ministry-of-communications',  # Ministry of Communications
    'power': 'ministry-of-power',  # Ministry of Power
    'railways': 'ministry-of-railways',  # Ministry of Railways
    'road-transport-highways': 'ministry-of-road-transport-and-highways',  # Ministry of Road Transport and Highways
    'rural-development': 'ministry-of-rural-development',  # Ministry of Rural Development
    'science-and-technology': 'ministry-of-science-and-technology',  # Ministry of Science and Technology
    'skill-development-entrepreneurship': 'ministry-of-skill-development-and-entrepreneurship',  # Ministry of Skill Development and Entrepreneurship
    'social-justice-and-empowerment': 'ministry-of-social-justice-and-empowerment',  # Ministry of Social Justice and Empowerment
    'statistics-and-programme-implementation': 'ministry-of-statistics-and-programme-implementation',  # Ministry of Statistics and Programme Implementation
    'steel': 'ministry-of-steel',  # Ministry of Steel
    'textiles': 'ministry-of-textiles',  # Ministry of Textiles
    'tribal-affairs': 'ministry-of-tribal-affairs',  # Ministry of Tribal Affairs
    'women-child-development': 'ministry-of-women-and-child-development',  # Ministry of Women and Child Development
    'youth-affairs-and-sports': 'ministry-of-youth-affairs-and-sports',  # Ministry of Youth Affairs and Sports
}
