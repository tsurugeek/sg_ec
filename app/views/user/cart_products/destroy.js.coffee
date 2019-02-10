<% if @cart.products_num > 0 %>
$('#total').replaceWith('<%= j render('user/carts/total', cart: @cart) %>');
$("#<%= dom_id(@product) %>").remove();
$("input[data-lock-version]").val(<%= @cart.lock_version %>);

<% else %>
$("#cart").remove();
<% end %>

showInfo("<%= j flash.notice %>")
showAlert("<%= j flash.alert %>")
