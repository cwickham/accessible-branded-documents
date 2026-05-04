// Identical to Quarto's default page.typ EXCEPT the trailing
// `if(logo)` background-image block has been removed so the brand
// wordmark is not auto-injected behind every page.
#set page(
  paper: $if(papersize)$"$papersize$"$else$"us-letter"$endif$,
  margin: $if(margin)$($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$)$else$(x: 1.25in, y: 1.25in)$endif$,
  numbering: $if(page-numbering)$"$page-numbering$"$else$none$endif$,
)
