Feature: Articles

    Background: Create a new user - Ensure it runs once for both different username/email combinations
        Given url apiUrl
        * def randomNum = Math.floor(Math.random() * 10000)
        * def username = 'user_' + randomNum
        * def email = 'test_' + randomNum + '@test.com'
        * def featureClasspath = 'classpath:com/paradigma0621/pockarate/example/helpers/createUser.feature'
        # Variables defined above to illustrate the call with arguments below
        * def userData = call read(featureClasspath) { username: "#(username)", email: "#(email)" }
        * def token = userData.tokenAuthorization

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
        And request
        """
        {
            "article": {
                "title": "Bla bla111",
                "tagList": [
                    "someTag"
                ],
                "description": "test test",
                "body": "body article message"
            }
        }
        """
        When method Post
        Then status 201
        And match response.article.title == 'Bla bla111'