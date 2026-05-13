;; Fold top-level module functions
(
  (function_item) @fold
)

;; Fold functions inside traits
(
  (trait_item
    body: (declaration_list
      (function_item) @fold
    )
  )
)

;; (Optional) Fold impl functions too
(
  (impl_item
    body: (declaration_list
      (function_item) @fold
    )
  
