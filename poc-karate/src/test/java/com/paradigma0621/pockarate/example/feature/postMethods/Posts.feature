Feature: Articles

    Background: Create a new user - Ensure it runs once for both different username/email combinations
        Given url 'https://conduit-api.bondaracademy.com/api/'
        Given path 'users'
        * def randomNum = Math.floor(Math.random() * 1000)
        * def username = 'user_' + randomNum
        * def email = 'test_' + randomNum + '@test.com'
        And request {"user": {"username": "#(username)" , "email": "#(email)", "password": "karate123"}}
        When method Post
        Then status 201
        * def token = response.user.token

    # Stand alone user creation
    #Scenario: Create a new user - Ensure it runs once for both different username/email combinations
    #    Given path 'users'
    #    And request {"user": {"username": "karate98764@test.com", "email": "abc98763@test.com","password": "karate123"}}
    #    When method Post
    #    Then status 201
    #    And match response.user.token == "#string"

    Scenario: Create a new article
        Given header Authorization = 'Token ' + token
        Given path 'articles'
        And request {"article": {"title": "Bla bla111", "tagList": ["someTag"],"description": "test test", "body": "body article message"}}
        When method Post
        Then status 201
        And match response.article.title == 'Bla bla111'