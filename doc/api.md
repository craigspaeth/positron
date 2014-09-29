# Positron's Private API

Positron uses MongoDB + Express to serve a private JSON API—the app serving this API can be found under /api. This will serve as the poor man's app & API usage documentation for now.

## Authentication

Positron uses Gravity to do authentication so all endpoints require a valid Artsy `X-Access-Token` header. Positron will use this to flatten, merge, and cache user data from Arty's API for easy client consumption. In this respect the /users endpoints act more like session management than strict user data. Use `DELETE /users/me` to remove this cached data, or in essence destroy your session.

## Architecture

Positron's API architecture is very thin and simple. Endpoints are split into folders under /resources. These contain routes (like controllers) that do auth/session/routing for a resource & [transaction scripts](http://martinfowler.com/eaaCatalog/transactionScript.html) (like a procedural version of your typical ActiveRecord-style models) that handle validation/retrieval/persistence of a resource. A root `index.coffee` app glues together the resource-level routing & "global" middleware found under `/lib`.

## Special `me` param

You may pass `me` in place of your user id, e.g. `/posts?author_id=me` to get your own posts. Positron reserves `me` as a keyword to look up your user based on the `X-Access-Token` header.

## Endpoints

Positron's API is a boring ol' [pragmatic REST](https://blog.apigee.com/detail/api_design_a_new_model_for_pragmatic_rest) API. It speaks only JSON, and closely follows plural resources with POST/GET/PUT/DELETE verbs for CRUD. Accepted endpoints listed below:

GET /posts
GET /posts/:id
POST /posts
PUT /posts/:id
DELETE /posts/:id

GET /users/me
DELETE /users/me