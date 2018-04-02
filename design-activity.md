<!-- What classes does each implementation include? Are the lists the same? -->
Implementation A classes include: CartEntry, ShoppingCart, and Order.
Implementation B classes include: CartEntry, ShoppingCart, and Order.
The lists are the same.

<!-- Write down a sentence to describe each class.-->
CartEntry creates object of each item to be placed in ShoppingCart, each item has a unit price and a quantity.
ShoppingCart stores a collection of each CartEntry object.
Order gives a total price based on the collection of items in ShoppingCart and applies a sales tax.

<!--How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.-->
Each class informs the following class with regards to its behavior and data.

<!-- What data does each class store? How (if at all) does this differ between the two implementations?-->
Each CartEntry object stores a unit price and quantity data. ShoppingCart stores objects of CartEntry. Order stores sales tax information and creates an instance of ShoppingCart. This information is consistent between the two implementations.

<!--What methods does each class have? How (if at all) does this differ between the two implementations?-->
Implementation A has an initialize method for each class and a total_price method for Order.
Implementation B has an initialize method for each class, a price method for both CartEntry and ShoppingCart, and a total_price method for Order.
Implementation B regulates individual pricing methods for each class, rather than consolidating all pricing logic in the total_price method of Order.

<!--Consider the Order#total_price method. In each implementation:
Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?
Does total_price directly manipulate the instance variables of other classes?-->
In Implementation A, logic to compute Order#total_price is retained in Order, meanwhile Implementation B has logic to compute price delegated to both ShoppingCart and CartEntry.

In Implementation A the CartEntry instance variables of @unit_price and @quantity are directly manipulated in Order#total_price, as is the ShoppingCart instance variable @entries. In Implementation B, only the return value for ShoppingCart#price is manipulated.

<!--If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?-->
This would change the unit_price of each CartEntry object based on quantity. Implementation B would be easier to modify, as we would only have to add a bit of logic to CartEntry#price to account for the change in price based quantity, with no other changes to existing code.

<!--Which implementation better adheres to the single responsibility principle?-->
Implementation B better adheres better to the single responsibility principle as each class deals with it's own bit of logic which will then inform a final output from Order#total_price. Rather than Order#total_price taking on the load of manipulating other class instance variables, it simply calls on the methods stored in the other classes to inform a final output.
<!--Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?-->

<!-- HOTEL REFACTORING
Describe what changes you would need to make to improve Hotel design, and how the resulting design would be an improvement. -->
Hotel::Admin takes on too many responsibilities, one area for single responsibility improvement would be to create a Hotel::Block class. The Admin class was creating blocks and directly modifying keys of these blocks. I was equating keys to attributes and this made the methods and testing bloated. To simplify, I should create a block class which has each key as an attribute which returns values. Also, any needed changes to each block should be a method in the block class. In Hotel::Admin, I should only be calling block attributes and methods to make changes to block objects. 
