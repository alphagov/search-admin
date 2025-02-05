# Controls
## About Vertex AI Search controls
[(Serving) controls][de-docs] are a Vertex AI Search ("Discovery Engine") feature that allows
modifying the behaviour of our search engine by changing how queries are interpreted, or how results
are returned.

Each individual control represents a specific modification of results. There are several types of
control ("actions") available to us, and we currently offer the following:
- "Boosts" allow us to increase or decrease the ranking of some content items in the results by a
  given factor
- "Filters" allow us to remove some content items from the results entirely

Both of these controls have a "filter expression" written in a Discovery Engine-specific [filter
query language] that allows us to say which content items they apply to. For example, they could
apply to all historic content (`is_historic = 1`), or a specific set of documents by link (`link:
ANY("/example1", "/example2")`).

## Implementation
In Search Admin, a `Control` is the main model representing a control on Discovery Engine. It has an
`action` associated using [delegated types], which is represented as a `Control::____Action` model
using the `Control::Actionable` concern with the specific functionality.

The action models are namespaced under the `Control` model to make clear that actions are tightly
coupled to controls, and don't make sense as standalone units.

[de-docs]: https://cloud.google.com/generative-ai-app-builder/docs/configure-serving-controls
[delegated types]: https://api.rubyonrails.org/classes/ActiveRecord/DelegatedType.html
[filter query language]:
https://cloud.google.com/generative-ai-app-builder/docs/filter-search-metadata#filter-expression-syntax
