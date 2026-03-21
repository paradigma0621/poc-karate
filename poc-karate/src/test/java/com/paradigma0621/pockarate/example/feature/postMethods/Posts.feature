Feature: Articles

    Background: Define URL
        Given url 'https://conduit-api.bondaracademy.com/api/'

    Scenario: Create a new user - Ensure it runs once for both different username/email combinations
        Given path 'users'
        And request {"user": {"username": "karate9876@test.com", "email": "abc9876@test.com","password": "karate123"}}
        When method Post
        Then status 201
        And match response.user.token == "#string"
