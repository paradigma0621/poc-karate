Feature: DeleteArticles

    Background: Create a new user - Ensure it runs once for both different username/email combinations
        Given url apiUrl
        * def randomNum = Math.floor(Math.random() * 1000)
        * def username = 'user_' + randomNum
        * def email = 'test_' + randomNum + '@test.com'
        * def featureClasspath = 'classpath:com/paradigma0621/pockarate/example/helpers/createUser.feature'
        # Variables defined above to illustrate the call with arguments below
        * def userData = call read(featureClasspath) { username: #(username), email: #(email) }
        * def token = userData.tokenAuthorization
        * def articleTitle = "Some words19"

    Scenario: Create and delete article
        # Create
        Given header Authorization = 'Token ' + token
        Given path 'articles'
        And request {"article": {"title": "#(articleTitle)", "tagList": ["someTag"], "description": "test test", "body": "body article message"}}
        When method Post
        Then status 201
        * def articleId = response.article.slug

        # Verify
        Given header Authorization = 'Token ' + token
        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].title == articleTitle

        # Delete
        Given header Authorization = 'Token ' + token
        Given path 'articles', articleId
        When method Delete
        Then status 204

        # Verify deletion
        Given header Authorization = 'Token ' + token
        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].title != articleTitle