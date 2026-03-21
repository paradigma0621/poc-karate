Feature: DeleteArticles

    Background: Create a new user - Ensure it runs once for both different username/email combinations
        Given url 'https://conduit-api.bondaracademy.com/api/'
        * def userData = callonce read('createUser.feature')
        * def token = userData.token
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