
Feature: Tests for the home page

    Scenario: Get all tags
        Given url 'https://conduit-api.bondaracademy.com/api/tags'
        When method Get
        Then status 200

