class CartController < ApplicationController
 
 before_filter :authenticate_user!, only: [:checkout]

 def add_to_cart
     lineitem = Lineitem.new
     lineitem.product_id = params[:product_id]
     lineitem.quantity = params[:quantity]
     lineitem.save

     lineitem.line_item_total = lineitem.product.price * lineitem.quantity
     lineitem.save

     redirect_to root_path
 end

 def view_order
     @lineitems = Lineitem.all
 end

 def checkout
    @lineitems = Lineitem.all
    @order = Order.new
    @order.user_id = current_user.id

    sum = 0

    @lineitems.each do |lineitem|
         # this is saying if order item quantity is not there add it to hash if it is increment one more then
        if @order.order_items[lineitem.product_id].nil?
             @order.order_items[lineitem.product_id] = lineitem.quantity
         else
             @order.order_items[lineitem.product_id] += lineitem.quantity
         end

        sum += lineitem.line_item_total
    end

    @order.subtotal = sum
    @order.sales_tax = sum * 0.07
    @order.grand_total = @order.subtotal + @order.sales_tax
    @order.save


    #updating inventory
    @lineitems.each do |lineitem|
        lineitem.product.quantity -= lineitem.quantity
        lineitem.product.save
    end

    #deleteing cart 
    Lineitem.destroy_all

end

end