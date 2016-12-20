# Geo Tracker
Geo based tasks tracker
Requires ruby 2.3, mongoDB

## Setup
Install ruby 2.3 and mongoDB.
Clone repo with:
`git clone git@github.com:hellaxe/geo_tracker.git`

In application folder run:
`bundle install`

In `./config/database.yml` change config for your database.

To add seed data run:
`rake db:seed`

To start server run:
`rackup`

## Tests
To run tests:
`rspec spec`

## API
### Show Tasks
Returns json data about tasks for user.
*   **Url**: `/api/tasks`
*   **Method**: `GET`
*   **Url Params**: 
    **Required**
    api_key=[string]
* **Success Response**
    *   **Code:** 200
        **Content:** `[{"_id":{"$oid":"5855"},"delivery_location":[38.70,-73.92],"description":"Similique sequi quia "...]`
* **Error Response**
    * **Code:** 401
    * **Content**: `{"errors":{"auth":"API Key does not exists"}}`

### Nearest Tasks
Returns json data with nearest new tasks for given driver.
*   **Url**: `/api/tasks/nearest`
*   **Method**: `GET`
*   **Url Params**: 
    **Required**
    api_key=[string] Driver only,
    form[object],
    form[loc]=[array] 1 dimensional array with 2 float values. *Example*: [20.2, 10.10]
    **Optional**
    form[limit]=[integer]
* **Success Response**
    *   **Code:** 200
        **Content:** `[{"_id":{"$oid":"5855"},"delivery_location":[38.70,-73.92],"description":"Similique sequi quia "...]`
* **Error Response**
    * **Code:** 401
    * **Content**: `{"errors":{"auth":"Forbidden action for this key"}}`

### Create Task
Creates task with provided data.
*   **Url**: `/api/tasks`
*   **Method**: `POST`
*   **Url Params**: 
    **Required**
    api_key=[string] Manager only,
    task:
    title=[string],
    description=[string],
    pickup_location=[array],
    delivery_location=[array]
* **Success Response**
    *   **Code:** 200
        **Content:** `[{"_id":{"$oid":"5855"},"delivery_location":[38.70,-73.92],"description":"Similique sequi quia "...]`

### Assign Task
Assigns task to given driver
*   **Url**: `/api/tasks/:id/assign`
*   **Method**: `PATCH`
*   **Url Params**: 
    **Required**
    api_key=[string] Driver only,
    id=[string]
* **Success Response**
    *   **Code:** 204
        **Content:** No Content

### Finish Task
Assigns task to given driver
*   **Url**: `/api/tasks/:id/finish`
*   **Method**: `PATCH`
*   **Url Params**: 
    **Required**
    api_key=[string] Driver only, 
    id=[string]
* **Success Response**
    *   **Code:** 204
        **Content:** No Content

## Errors:
Sometimes API may return errors. Most frequent errors listed below:
401 - Unauthorized Action. All actions requires API key. Note that you can't access for driver only actions as manager and visa versa.
500 - Impossible state transition. You can't finish new task, and assign already assigned or finished task.