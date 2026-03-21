# When a feature has more than one scenario, the Background is executed before each scenario.
# In delete.feature, this causes the user to be created multiple times, leading to an error.
# To avoid this, we isolate the user creation and use:
# * def userData = callonce read('createUser.feature')
# This ensures the user is created only once, preventing duplicate errors.
Feature: Create user just once
    @ignore
    Scenario:
        Given url 'https://conduit-api.bondaracademy.com/api/'
        Given path 'users'
        * def randomNum = Math.floor(Math.random() * 1000)
        * def username = 'user_' + randomNum
        * def email = 'test_' + randomNum + '@test.com'
        And request {"user": {"username": "#(username)" , "email": "#(email)", "password": "karate123"}}
        When method Post
        Then status 201
        * def token = response.user.token