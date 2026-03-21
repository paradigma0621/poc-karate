
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
