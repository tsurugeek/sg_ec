<% unless @cart_product.errors[:num].present? %>
$('#total').replaceWith('<%= j render('user/carts/total', cart: @cart) %>');
$('#<%= dom_id(@cart_product.product, :total) %>').text('<%= number_to_currency @cart_product.total %>');
<% end %>

$("#<%= dom_id(@cart_product.product, :num) %>").html('<%= j render('user/carts/num', cart_product: @cart_product) %>');

$("input[data-lock-version]").val('<%= @cart_product.purchase.lock_version %>');

showInfo("<%= j flash.notice %>")
showAlert("<%= j flash.alert %>")
