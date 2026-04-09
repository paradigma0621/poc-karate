@mytag
Feature: Tests for the home page
    Background: Define URL
        Given url 'https://conduit-api.bondaracademy.com/api/'

    Scenario: Get all tags
        Given path 'tags'
        When method Get
        Then status 200
        # And match response.tags contains 'Start for Free'
        And match response.tags contains ['Start for Free', 'Slack']
        And match response.tags !contains 'abc123'
        And match response.tags contains any ['abc123', 'Slack', 'xyz12321']
        And match response.tags == "#array"

    Scenario: Get 10 articles from the page using parameters
        # Use case 1
        #    Given url 'https://conduit-api.bondaracademy.com/api/articles?limit=10&offset=0'

        # Use case 2
        # Given param limit = 10
        # Given param offset = 0
        #    Given url 'https://conduit-api.bondaracademy.com/api/articles'

        # Use case 3
        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        # The array returned has 10 elements
        And match response.articles == '#[10]'
        # The element 'articlesCount' has value = 10
        And match response.articlesCount == 10
        And match response == { "articles": "#array", "articlesCount": 10}
        # Creation date year = 2024?
        And match response.articles[0].createdAt contains '2024'
        # At least one 'favoritesCount' value is 464
        And match response.articles[*].favoritesCount contains 464
        # At least one 'author.bio' is null
        And match response.articles[*].author.bio contains null
        # At least one 'bio' field in the response is null (not only 'author.bio')
        And match response..bio contains null
        # All 'following' fields in the response are false
        And match each response..following == false
        # All 'following' fields in the response are booleans
        And match each response..following == '#boolean'
        # All 'favoritesCount' fields in the response are numbers
        And match each response..favoritesCount == '#number'
        # The 'bio' field may be missing, null, or a string
        And match each response..bio == '##string'