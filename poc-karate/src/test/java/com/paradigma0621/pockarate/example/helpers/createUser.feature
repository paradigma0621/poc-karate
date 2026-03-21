# When a feature has more than one scenario, the Background is executed before each scenario.
# In delete.feature, this causes the user to be created multiple times, leading to an error.
# To avoid this, we isolate the user creation and use:
# * def userData = callonce read('createUser.feature')
# This ensures the user is created only once, preventing duplicate errors.
# Note: this feature is outside the files xTest.java, so do not run automatically
Feature: Create user just once
    Scenario:
        Given url 'https://conduit-api.bondaracademy.com/api/'
        Given path 'users'
        And request {"user": {"username": "#(username)" , "email": "#(email)", "password": "karate123"}}
        * print 'Username [DEBUG]:', username
        * print 'Email  [DEBUG]:', email
        When method Post
        Then status 201
        * def tokenAuthorization = response.user.token