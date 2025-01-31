----------------------------------------------- DROP Tables ----------------------------------------------------------------------------------
--DROP TABLE Orders;
--DROP TABLE Cart;
--DROP TABLE CartDetails;
--DROP TABLE Items;
--DROP TABLE Menu;
--DROP TABLE RestaurantPromocodeRelation;
--DROP TABLE Promocodes;
--DROP TABLE Customers;
--DROP TABLE CustomerAddress;
--DROP TABLE Restaurants;
--DROP TABLE DeliveryAgents;
--DROP TABLE PaymentTypes;

----------------------------------------------- Table Creation ---------------------------------------------------------------------------------------------
-- 1. CustomerAddress
CREATE TABLE CustomerAddress (
    AddressID VARCHAR(20) PRIMARY KEY,
    StreetAddress VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    ZipCode VARCHAR(10) NOT NULL,
    Country VARCHAR(50) NOT NULL
);
 
-- 2. Customers
CREATE TABLE Customers (
    CustomerID VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(50) UNIQUE NOT NULL,
    PhoneNumber INTEGER NOT NULL,
    AddressID VARCHAR(20) NOT NULL,
    CONSTRAINT FK_CustomerAddress FOREIGN KEY (AddressID) REFERENCES CustomerAddress(AddressID)
);
 
-- 3. Restaurants
CREATE TABLE Restaurants (
    RestaurantID VARCHAR(20) PRIMARY KEY,
    RName VARCHAR(50) NOT NULL,
    CuisineType VARCHAR(100) NOT NULL,
    Rating NUMERIC(2, 1),
    Location VARCHAR(255) NOT NULL
);
 
-- 4. Promocodes
CREATE TABLE Promocodes (
    PromoCodeID VARCHAR(20) PRIMARY KEY,
    MinimumOrder NUMERIC(6, 2),
    MaximumDiscount NUMERIC(6, 2),
    Details VARCHAR(225),
    PromoCode VARCHAR(20),
    OfferPercentage NUMERIC(2) CHECK (OfferPercentage <= 100)
);
 
-- 5. RestaurantPromocodeRelation
CREATE TABLE RestaurantPromocodeRelation (
    OfferID VARCHAR(20) PRIMARY KEY,
    PromoCodeID VARCHAR(20),
    RestaurantID VARCHAR(20),
    CONSTRAINT FK_Relation_Promo FOREIGN KEY (PromoCodeID) REFERENCES Promocodes(PromoCodeID),
    CONSTRAINT FK_Relation_Restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);
 
-- 6. Menu
CREATE TABLE Menu (
    MenuID VARCHAR(20) PRIMARY KEY,
    RestaurantID VARCHAR(20),
    Menutype VARCHAR(255) NOT NULL,
    CONSTRAINT FK_Menu_Restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);
 
-- 7. Items
CREATE TABLE Items (
    MenuID VARCHAR(20),
    ItemID VARCHAR(20),
    ItemName VARCHAR(100) NOT NULL,
    Description VARCHAR(225),
    Price NUMERIC(8, 2) NOT NULL,
    CONSTRAINT PK_Items PRIMARY KEY (MenuID, ItemID),
    CONSTRAINT FK_Items_Menu FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
);
 
-- 8. Cart
CREATE TABLE Cart (
    CartID VARCHAR(20) PRIMARY KEY,
    CreatedBy VARCHAR(20),
    CreationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Cart_Customer FOREIGN KEY (CreatedBy) REFERENCES Customers(CustomerID)
);
 
-- 9. CartDetails
CREATE TABLE CartDetails (
    CartID VARCHAR(20),
    MenuID VARCHAR(20),
    ItemID VARCHAR(20),
    Quantity INTEGER NOT NULL,
    AddedBy VARCHAR(20),
    Customization VARCHAR(50),
    Price NUMERIC(8, 2) NOT NULL,
    CONSTRAINT PK_CartDetails PRIMARY KEY (CartID, ItemID, AddedBy),
    CONSTRAINT FK_CartDetail_Item FOREIGN KEY (MenuID, ItemID) REFERENCES Items(MenuID, ItemID),
    CONSTRAINT FK_CartDetail_Customer FOREIGN KEY (AddedBy) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_CartDetail_Cart FOREIGN KEY (CartID) REFERENCES Cart(CartID)
);
 
-- 10. DeliveryAgents
CREATE TABLE DeliveryAgents (
    DeliveryAgentID VARCHAR(20) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber NUMERIC(15) NOT NULL,
    VehicleNumber VARCHAR(50) NOT NULL
);
 
-- 11. PaymentTypes
CREATE TABLE PaymentTypes (
    PaymentTypeID VARCHAR(20) PRIMARY KEY,
    PaymentMethod VARCHAR(50) NOT NULL
);
 
-- 12. Orders
CREATE TABLE Orders (
    OrderID VARCHAR(20) PRIMARY KEY,
    CartID VARCHAR(20),
    CustomerID VARCHAR(20),
    RestaurantID VARCHAR(20),
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DeliveryAddressID VARCHAR(20),
    TotalAmount NUMERIC(10, 2) NOT NULL,
    OfferID VARCHAR(20),
    EcoDelivery VARCHAR(5) DEFAULT 'FALSE' CHECK (EcoDelivery IN ('TRUE', 'FALSE')),
    DiscountApplied NUMERIC(5, 2) DEFAULT 0,
    DeliveryAgentID VARCHAR(20),
    OrderStatus VARCHAR(50) DEFAULT 'Pending' CHECK (OrderStatus IN ('Pending', 'In Progress', 'Delivered', 'Cancelled')),
    FoodReview INTEGER,
    RestaurantReview INTEGER,
    PaymentTypeID VARCHAR(50),
    CONSTRAINT FK_Orders_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Orders_Restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    CONSTRAINT FK_Orders_Address FOREIGN KEY (DeliveryAddressID) REFERENCES CustomerAddress(AddressID),
    CONSTRAINT FK_Orders_Offer FOREIGN KEY (OfferID) REFERENCES RestaurantPromocodeRelation(OfferID),
    CONSTRAINT FK_Orders_Cart FOREIGN KEY (CartID) REFERENCES Cart(CartID),
    CONSTRAINT FK_Orders_Agent FOREIGN KEY (DeliveryAgentID) REFERENCES DeliveryAgents(DeliveryAgentID),
    CONSTRAINT FK_Orders_PaymentType FOREIGN KEY (PaymentTypeID) REFERENCES PaymentTypes(PaymentTypeID)
);

----------------------------------------------- Populating the Tables ---------------------------------------------------------------------------------------------
-- 1. CustomerAddress Insertions
BEGIN
    INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
    VALUES ('ADDR001', '123 Maple St', 'Boston', 'MA', '02108', 'USA');
    INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
    VALUES ('ADDR002', '456 Elm St', 'Cambridge', 'MA', '02139', 'USA');
    INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
    VALUES ('ADDR003', '789 Oak St', 'Somerville', 'MA', '02144', 'USA');
    INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
    VALUES ('ADDR004', '321 Pine St', 'Brookline', 'MA', '02445', 'USA');
    INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
    VALUES ('ADDR005', '654 Birch St', 'Newton', 'MA', '02458', 'USA');
    INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
    VALUES ('ADDR006', '987 Cedar St', 'Quincy', 'MA', '02170', 'USA');
    INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
    VALUES ('ADDR007', '213 Spruce St', 'Waltham', 'MA', '02451', 'USA');
    INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
    VALUES ('ADDR008', '546 Chestnut St', 'Medford', 'MA', '02155', 'USA');
    INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
    VALUES ('ADDR009', '879 Willow St', 'Watertown', 'MA', '02472', 'USA');
    INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
    VALUES ('ADDR010', '132 Poplar St', 'Malden', 'MA', '02148', 'USA');
    Commit;
End;

 -- 2. Customers Insertions
Begin   
    INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST001', 'John Doe', 'john.doe@gmail.com', 1234567890, 'ADDR001');
    INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST002', 'Jane Smith', 'jane.smith@gmail.com', 2345678901, 'ADDR002');
    INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST003', 'Alice Johnson', 'alice.johnson@gmail.com', 3456789012, 'ADDR003');
    INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST004', 'Bob Brown', 'bob.brown@gmail.com', 4567890123, 'ADDR004');
    INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST005', 'Eve Davis', 'eve.davis@gmail.com', 5678901234, 'ADDR005');
    INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST006', 'Charlie Wilson', 'charlie.wilson@gmail.com', 6789012345, 'ADDR006');
    INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST007', 'David Clark', 'david.clark@gmail.com', 7890123456, 'ADDR007');
    INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST008', 'Fiona Harris', 'fiona.harris@gmail.com', 8901234567, 'ADDR008');
    INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST009', 'George Lee', 'george.lee@gmail.com', 9012345678, 'ADDR009');
    INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST010', 'Hannah Adams', 'hannah.adams@gmail.com', 1234567899, 'ADDR010');
    COMMIT;
END;

 -- 3. Restaurants Insertions
BEGIN
    INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST001', 'Taste of Italy', 'Italian', 4.5, '123 Little Italy St, Boston, MA');
    INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST002', 'Sushi Paradise', 'Japanese', 4.8, '456 Sushi Ave, Cambridge, MA');
    INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST003', 'Spice Symphony', 'Indian', 4.7, '789 Curry Ln, Somerville, MA');
    INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST004', 'Burger Barn', 'American', 4.2, '321 Burger Rd, Brookline, MA');
    INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST005', 'Taco Haven', 'Mexican', 4.6, '654 Taco St, Newton, MA');
    INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST006', 'Dragon Wok', 'Chinese', 4.4, '987 Dragon Blvd, Quincy, MA');
    INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST007', 'Le Petit Bistro', 'French', 4.9, '213 Paris Way, Waltham, MA');
    INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST008', 'Mediterraneo', 'Mediterranean', 4.3, '546 Olive Dr, Medford, MA');
    INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST009', 'Vegan Delights', 'Vegan', 4.5, '879 Plant-Based Pl, Watertown, MA');
    INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST010', 'BBQ Junction', 'Barbecue', 4.0, '132 Smokehouse Ln, Malden, MA');
    COMMIT;
END;

 -- 4. Promocodes Insertions
BEGIN
    INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO001', 20.00, 10.00, '10% off on orders above $20', 'SAVE10', 10);
    INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO002', 50.00, 20.00, '20% off on orders above $50', 'FEAST20', 20);
    INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO003', 30.00, 15.00, '15% off on first-time orders', 'FIRST15', 15);
    INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO004', 40.00, 25.00, 'Flat $25 off on orders above $40', 'FLAT25', 25);
    INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO005', 15.00, 5.00, '5% off on all orders', 'EVERY5', 5);
    INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO006', 100.00, 50.00, '50% off up to $50 for large orders', 'BIG50', 50);
    INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO007', 75.00, 30.00, '30% off for loyal customers', 'LOYAL30', 30);
    INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO008', 10.00, 3.00, 'Get $3 off on any order', 'QUICK3', 30);
    INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO009', 25.00, 12.50, '12.5% off for weekend orders', 'WEEKEND12', 12);
    INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO010', 60.00, 20.00, 'Free dessert with orders above $60', 'FREE20', 20);
    COMMIT;
END;

-- 5. RestaurantPromocodeRelation Insertions
BEGIN
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID001', 'PROMO001', 'REST001');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID002', 'PROMO002', 'REST001');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID003', 'PROMO003', 'REST002'); 
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID004', 'PROMO004', 'REST003');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID005', 'PROMO005', 'REST003');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID006', 'PROMO006', 'REST004');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID007', 'PROMO001', 'REST004');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID008', 'PROMO007', 'REST005');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID009', 'PROMO008', 'REST005');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID010', 'PROMO003', 'REST006');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID011', 'PROMO009', 'REST007');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID012', 'PROMO010', 'REST007');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID013', 'PROMO002', 'REST008');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID014', 'PROMO006', 'REST009');
    INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
    VALUES ('OFFID015', 'PROMO004', 'REST010');
    Commit;
End;

-- 6. Menu Insertions
    INSERT INTO Menu (MenuID, RestaurantID, Menutype)
    VALUES ('MENU001', 'REST001', 'Veg');
    INSERT INTO Menu (MenuID, RestaurantID, Menutype)
    VALUES ('MENU002', 'REST001', 'NonVeg');
    INSERT INTO Menu (MenuID, RestaurantID, Menutype)
    VALUES ('MENU003', 'REST002', 'Vegan');
    INSERT INTO Menu (MenuID, RestaurantID, Menutype)
    VALUES ('MENU004', 'REST002', 'Veg');
    INSERT INTO Menu (MenuID, RestaurantID, Menutype)
    VALUES ('MENU005', 'REST003', 'NonVeg');
    INSERT INTO Menu (MenuID, RestaurantID, Menutype)
    VALUES ('MENU006', 'REST004', 'Vegan');
    INSERT INTO Menu (MenuID, RestaurantID, Menutype)
    VALUES ('MENU007', 'REST005', 'Veg');
    INSERT INTO Menu (MenuID, RestaurantID, Menutype)
    VALUES ('MENU008', 'REST006', 'NonVeg');
    INSERT INTO Menu (MenuID, RestaurantID, Menutype)
    VALUES ('MENU009', 'REST007', 'Vegan');
    INSERT INTO Menu (MenuID, RestaurantID, Menutype)
    VALUES ('MENU010', 'REST008', 'Veg');
    COMMIT;
END;

-- 7. Items Insertions
BEGIN
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU001', 'ITEM001', 'Veg Cheese Pizza', 'Classic cheese pizza with mozzarella cheese, perfect for vegetarians', 12.99);
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU001', 'ITEM002', 'Veg Burger', 'A healthy vegetable burger with lettuce, tomato, and a vegan patty', 8.99);    
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU001', 'ITEM003', 'Veg Pasta', 'Pasta served with a mix of fresh veggies', 10.49);
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU002', 'ITEM004', 'Chicken Tikka', 'Boneless chicken pieces marinated in spices and grilled', 14.99);
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU002', 'ITEM005', 'NonVeg Burger', 'A delicious burger with a grilled chicken patty', 9.49);
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU002', 'ITEM006', 'Beef Stew', 'Slow-cooked beef stew with vegetables', 16.99);
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU003', 'ITEM007', 'Vegan Salad', 'A fresh mixed greens salad with a variety of veggies', 7.99);
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU003', 'ITEM008', 'Vegan Tacos', 'Tacos filled with sautéed veggies and served with avocado', 9.49);
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU003', 'ITEM009', 'Vegan Stir-fry', 'A mix of stir-fried vegetables served with rice', 11.99);
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU004', 'ITEM010', 'Vegetable Samosas', 'Crispy pastry filled with spiced vegetables', 4.99);
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU004', 'ITEM011', 'Paneer Tikka', 'Grilled paneer marinated with yogurt and spices', 12.99);
    INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    VALUES ('MENU004', 'ITEM012', 'Aloo Gobi', 'A dish made from potatoes and cauliflower cooked with spices', 8.49);
    COMMIT;
END;

-- 8. DeliveryAgents Insertions
BEGIN
    INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
    VALUES ('DELAG001', 'John', 'Doe', 1234567890, 'AB123CD');
    INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
    VALUES ('DELAG002', 'Jane', 'Smith', 2345678901, 'EF456GH');
    INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
    VALUES ('DELAG003', 'Alice', 'Johnson', 3456789012, 'IJ789KL');
    INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
    VALUES ('DELAG004', 'Bob', 'Brown', 4567890123, 'MN012OP');
    INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
    VALUES ('DELAG005', 'Charlie', 'Davis', 5678901234, 'QR345ST');
    INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
    VALUES ('DELAG006', 'David', 'Martinez', 6789012345, 'UV678WX');
    INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
    VALUES ('DELAG007', 'Eve', 'Wilson', 7890123456, 'YZ901AB');
    INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
    VALUES ('DELAG008', 'Frank', 'Moore', 8901234567, 'CD234EF');
    INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
    VALUES ('DELAG009', 'Grace', 'Taylor', 9012345678, 'GH567IJ');
    INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
    VALUES ('DELAG010', 'Hank', 'Anderson', 1123456789, 'KL890MN');
    COMMIT;
END;

--9. PaymentTypes Insertions
BEGIN
    INSERT INTO PaymentTypes (PaymentTypeID, PaymentMethod)
    VALUES ('PAYMT001', 'COD');
    INSERT INTO PaymentTypes (PaymentTypeID, PaymentMethod)
    VALUES ('PAYMT002', 'CREDIT CARD');
    INSERT INTO PaymentTypes (PaymentTypeID, PaymentMethod)
    VALUES ('PAYMT003', 'DEBIT CARD');
    INSERT INTO PaymentTypes (PaymentTypeID, PaymentMethod)
    VALUES ('PAYMT004', 'PAYPAL');
    INSERT INTO PaymentTypes (PaymentTypeID, PaymentMethod)
    VALUES ('PAYMT005', 'BANK TRANSFER');
    COMMIT;
END;

-- 10. Cart Insertions
BEGIN
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART001', 'CUST001', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART002', 'CUST002', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART003', 'CUST003', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART004', 'CUST004', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART005', 'CUST005', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART006', 'CUST001', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART007', 'CUST002', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART008', 'CUST006', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART009', 'CUST007', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART010', 'CUST003', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART011', 'CUST008', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART012', 'CUST009', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART013', 'CUST004', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART014', 'CUST010', CURRENT_TIMESTAMP);
    INSERT INTO Cart (CartID, CreatedBy, CreationDate)
    VALUES ('CART015', 'CUST005', CURRENT_TIMESTAMP);
    COMMIT;
END;

-- 11. CartDetails Insertions
BEGIN
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART001', 'MENU001', 'ITEM001', 2, 'CUST001', 'No Onion', 12.99);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART001', 'MENU001', 'ITEM002', 2, 'CUST001', 'No Onion', 8.99);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART001', 'MENU001', 'ITEM003', 1, 'CUST002', 'No Onion', 10.49);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART002', 'MENU001', 'ITEM003', 2, 'CUST002', 'No Garlic', 10.49);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART002', 'MENU002', 'ITEM004', 2, 'CUST003', 'No Preference', 14.99);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART002', 'MENU001', 'ITEM002', 1, 'CUST004', 'No Onion', 8.99);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART003', 'MENU002', 'ITEM005', 1, 'CUST005', 'Gluten Free', 9.49);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART003', 'MENU002', 'ITEM006', 1, 'CUST006', 'No Onion', 16.99);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART003', 'MENU002', 'ITEM005', 3, 'CUST008', 'No Garlic', 9.49);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART004', 'MENU003', 'ITEM007', 2, 'CUST007', 'No Onion', 7.99);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART005', 'MENU001', 'ITEM003', 1, 'CUST002', 'No Garlic', 10.49);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART005', 'MENU002', 'ITEM006', 1, 'CUST006', 'No Onion', 16.999);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART005', 'MENU002', 'ITEM004', 2, 'CUST003', 'No Preference', 14.99);
    INSERT INTO CartDetails (CartID, MenuID, ItemID, Quantity, AddedBy, Customization, Price)
    VALUES ('CART005', 'MENU004', 'ITEM011', 2, 'CUST010', 'No Onion', 12.99);
    COMMIT;
END;

-- 10. Insert into Orders table
BEGIN
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD001', 'CART001', 'CUST001', 'REST001', CURRENT_TIMESTAMP, 'ADDR001', 35.97, 'OFFID001', 'FALSE', 5.00, 'DELAG001', 'Delivered', 4, 4, 'PAYMT002');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD002', 'CART002', 'CUST002', 'REST003', CURRENT_TIMESTAMP, 'ADDR002', 25.48, 'OFFID004', 'FALSE', 3.50, 'DELAG003', 'In Progress', NULL, NULL, 'PAYMT004');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD003', 'CART003', 'CUST003', 'REST005', CURRENT_TIMESTAMP, 'ADDR003', 42.46, 'OFFID008', 'TRUE', 2.00, 'DELAG005', 'Delivered', 5, 5, 'PAYMT001');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD004', 'CART004', 'CUST004', 'REST002', CURRENT_TIMESTAMP, 'ADDR004', 54.97, 'OFFID003', 'FALSE', 10.00, 'DELAG002', 'Delivered', 3, 4, 'PAYMT003');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD005', 'CART005', 'CUST005', 'REST004', CURRENT_TIMESTAMP, 'ADDR005', 36.47, 'OFFID006', 'TRUE', 5.00, 'DELAG004', 'In Progress', NULL, NULL, 'PAYMT005');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD006', 'CART006', 'CUST001', 'REST006', CURRENT_TIMESTAMP, 'ADDR001', 67.97, 'OFFID010', 'FALSE', 15.00, 'DELAG006', 'Delivered', 5, 5, 'PAYMT002');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD007', 'CART007', 'CUST002', 'REST007', CURRENT_TIMESTAMP, 'ADDR002', 45.97, 'OFFID011', 'TRUE', 7.50, 'DELAG007', 'Delivered', 4, 4, 'PAYMT004');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD008', 'CART008', 'CUST006', 'REST008', CURRENT_TIMESTAMP, 'ADDR006', 33.47, 'OFFID013', 'FALSE', 4.00, 'DELAG008', 'In Progress', NULL, NULL, 'PAYMT001');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD009', 'CART009', 'CUST007', 'REST009', CURRENT_TIMESTAMP, 'ADDR007', 62.97, 'OFFID014', 'TRUE', 12.50, 'DELAG009', 'Delivered', 5, 4, 'PAYMT003');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD010', 'CART010', 'CUST003', 'REST010', CURRENT_TIMESTAMP, 'ADDR003', 39.97, 'OFFID015', 'FALSE', 6.00, 'DELAG010', 'Delivered', 4, 5, 'PAYMT005');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD011', 'CART011', 'CUST008', 'REST001', CURRENT_TIMESTAMP, 'ADDR008', 52.97, 'OFFID001', 'TRUE', 8.00, 'DELAG001', 'Delivered', 5, 5, 'PAYMT002');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD012', 'CART012', 'CUST009', 'REST002', CURRENT_TIMESTAMP, 'ADDR009', 37.97, 'OFFID003', 'FALSE', 5.50, 'DELAG002', 'In Progress', NULL, NULL, 'PAYMT004');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD013', 'CART013', 'CUST004', 'REST003', CURRENT_TIMESTAMP, 'ADDR004', 46.97, 'OFFID004', 'TRUE', 7.00, 'DELAG003', 'Delivered', 4, 4, 'PAYMT001');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD014', 'CART014', 'CUST010', 'REST004', CURRENT_TIMESTAMP, 'ADDR010', 59.97, 'OFFID006', 'FALSE', 9.50, 'DELAG004', 'In Progress', NULL, NULL, 'PAYMT005');
    INSERT INTO Orders (OrderID, CartID, CustomerID, RestaurantID, OrderDate, DeliveryAddressID, TotalAmount, OfferID, EcoDelivery, DiscountApplied, DeliveryAgentID, OrderStatus, FoodReview, RestaurantReview, PaymentTypeID)
    VALUES ('ORD015', 'CART015', 'CUST005', 'REST005', CURRENT_TIMESTAMP, 'ADDR005', 41.97, 'OFFID008', 'TRUE', 6.50, 'DELAG005', 'Delivered', 5, 5, 'PAYMT003'); 
    COMMIT;
END;


--------------------------------------------- SQL Execution -------------------------------------------------------
---------------------------------------- 2 users join the Application------------------------------------------------
-- Update the CustomerAddresss Table with the 2 new Customers Address details.
-- AddressID got Auto Incremented for the new entry in the database
CREATE SEQUENCE AddressID_seq
START WITH 11
INCREMENT BY 1
NOCACHE;

INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
VALUES('ADDR' || TO_CHAR(AddressID_seq.NEXTVAL, 'FM000'), '1 Tom St', 'Boston', 'MA', '02108', 'USA');
INSERT INTO CustomerAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
VALUES('ADDR' || TO_CHAR(AddressID_seq.NEXTVAL, 'FM000'), '46 Maple St', 'Roxbury', 'MA', '02139', 'USA');


-- Update the Customer Table with the 2 new Customers details.
-- CustomerID got Auto Incremented for the new entry in the database
CREATE SEQUENCE CustomerID_seq
START WITH 11
INCREMENT BY 1
NOCACHE;

INSERT INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST' || TO_CHAR(CustomerID_seq.NEXTVAL, 'FM000'), 'Tom Wilson', 'tom.wilson@gmail.com', 6171234567, 'ADDR011');   
Insert INTO Customers (CustomerID, Name, Email, PhoneNumber, AddressID)
    VALUES ('CUST' || TO_CHAR(CustomerID_seq.NEXTVAL, 'FM000'), 'Sarah Parker', 'sarah.parker@gmail.com', 6177654321, 'ADDR012');


---------------------------------------- 1 new restaurant joins the Application------------------------------------------------
-- Update the Restaurant Table with the 1 new restaurant details.
-- RestaurantID got Auto Incremented for the new entry in the database
CREATE SEQUENCE RestaurantID_seq
START WITH 11
INCREMENT BY 1
NOCACHE;

INSERT INTO Restaurants (RestaurantID, RName, CuisineType, Rating, Location)
    VALUES ('REST' || TO_CHAR(RestaurantID_seq.NEXTVAL, 'FM000'), 'Machu Picchu', 'Peruvian', 4.5, '307 Somerville Ave, Somerville, MA');
    

---------------------------------------- 1 new PromoCode is introduced by the restaurants------------------------------------------------
-- Update the Promocode Table with the 1 new Promocode details.
-- PcomoCodeID got Auto Incremented for the new entry in the database
CREATE SEQUENCE PromoCode_seq
START WITH 11
INCREMENT BY 1
NOCACHE;

INSERT INTO Promocodes (PromoCodeID, MinimumOrder, MaximumDiscount, Details, PromoCode, OfferPercentage)
    VALUES ('PROMO' || TO_CHAR(PromoCode_seq.NEXTVAL, 'FM000'), 35, 5, '$5 off on purchase of $35', 'OFF5', 14.2);

---------------------------------------- The new PromoCode is offered by 3 restaurants ------------------------------------------------
-- Update the RestaurantPromocodeRelation Table with the new Promocode details and assigning it to the relevant 3 restaurants.
-- OdderID got Auto Incremented for the new entry in the database
CREATE SEQUENCE OfferID_seq
START WITH 16
INCREMENT BY 1
NOCACHE;
-- DROP SEQUENCE OfferID_seq;

DECLARE
    v_promo_code_id VARCHAR(10);
BEGIN
    -- Fetch the PromoCodeID for PromoCode 'OFF5'
    SELECT PromoCodeID 
    INTO v_promo_code_id
    FROM Promocodes
    WHERE PromoCode = 'OFF5';

    -- Insert into RestaurantPromocodeRelation for each restaurant
    FOR i IN (SELECT 'REST008' AS RestaurantID FROM dual
              UNION ALL
              SELECT 'REST009' FROM dual
              UNION ALL
              SELECT 'REST010' FROM dual) LOOP
        INSERT INTO RestaurantPromocodeRelation (OfferID, PromoCodeID, RestaurantID)
        VALUES ('OFFID' || TO_CHAR(OfferID_seq.NEXTVAL, 'FM000'), v_promo_code_id, i.RestaurantID);
    END LOOP;

    COMMIT;
END;


---------------------------------------- Restaurants REST005 and REST006 has introduced 1 new Menu in their restaurants MENU011 AND MENU012 ------------------------------------------------
-- Update the Menu Table with the new Mneu Details.
-- MenuID got Auto Incremented for the new entry in the database
INSERT INTO Menu (MenuID, RestaurantID, Menutype)
SELECT 'MENU' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(MenuID, 5))) + 1, 'FM000'), 'REST005', 'NonVeg'
FROM Menu;
 
-- Second insert for REST006
INSERT INTO Menu (MenuID, RestaurantID, Menutype)
SELECT 'MENU' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(MenuID, 5))) + 1, 'FM000'), 'REST006', 'Pescatarian'
FROM Menu;
 
COMMIT;

------------------------------------------- Updating the newly introduced Menu with 2 Items ID each ------------------------------------------------------------------------------------------
-- Update the Item Table with the new MenuID and ItemID Details.
-- ItemID got Auto Incremented for the new entry of Item in the database
INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
SELECT 
    'MENU011',  
    'ITEM' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(ItemID, 5))) + 1, 'FM000'), -- Since Chicken 65 is new, therefore new ItemID is incemented
    'Chicken 65',
    'Spicy, deep-fried chicken dish with curry leaves and aromatic Indian spices, served with mint chutney',
    22.16
FROM Items;
COMMIT;

INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
    Values ('MENU011',  'ITEM005',	'NonVeg Burger', 'A delicious burger with a grilled chicken patty', 9.49); -- Since Item005 already exists therefore no increment

INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
SELECT 
    'MENU012',  
    'ITEM' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(ItemID, 5))) + 1, 'FM000'), -- Since Fish Fry is new, therefore new ItemID is incemented
    'Fish Fry',
    'Crispy fried fish fillets marinated in aromatic spices, served with tartar sauce and lemon wedges',
    18.99
FROM Items;
COMMIT;

INSERT INTO Items (MenuID, ItemID, ItemName, Description, Price)
SELECT 
    'MENU012',  
    'ITEM' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(ItemID, 5))) + 1, 'FM000'), -- Since Grilled Salmon is new, therefore new ItemID is incemented
    'Grilled Salmon',
    'Fresh Atlantic salmon fillet grilled to perfection with herbs, served with roasted vegetables and lemon butter sauce',
    24.99
FROM Items;
COMMIT;

------------------------------------------- 2 new Delivery Agent joined the Application ------------------------------------------------------------------------------------------
-- Update the DeliveryAgents Table with the new Delivery Agent Details.
-- DeliveryAgentID got Auto Incremented for the new entry in the database
-- Add first delivery agent
INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
SELECT 
    'DELAG' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(DeliveryAgentID, 6))) + 1, 'FM000'),
    'Miguel',
    'Rodriguez',
    6175559012,
    'WX' || TO_CHAR(DBMS_RANDOM.VALUE(100,999),'FM000') || 'YZ'
FROM DeliveryAgents;
 
-- Add second delivery agent
INSERT INTO DeliveryAgents (DeliveryAgentID, FirstName, LastName, PhoneNumber, VehicleNumber)
SELECT 
    'DELAG' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(DeliveryAgentID, 6))) + 1, 'FM000'),
    'Sarah',
    'O''Connor',
    6175558234,
    'BC' || TO_CHAR(DBMS_RANDOM.VALUE(100,999),'FM000') || 'DE'
FROM DeliveryAgents;
COMMIT;

------------------------------------------- 2 new Payment Type "Apple Pay" has been introdiuced in the Application ------------------------------------------------------------------------------------------
-- Update the PaymentTypes Table with the new Payment Type Details.
-- PaymentTypeID got Auto Incremented for the new entry in the database
INSERT INTO PaymentTypes (PaymentTypeID, PaymentMethod)
SELECT 
   'PAYMT' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(PaymentTypeID, 6))) + 1, 'FM000'),
   'APPLE PAY'
FROM PaymentTypes;
 
-- Add Klarna
INSERT INTO PaymentTypes (PaymentTypeID, PaymentMethod)
SELECT 
   'PAYMT' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(PaymentTypeID, 6))) + 1, 'FM000'),
   'KLARNA'
FROM PaymentTypes;
 
COMMIT;

------------------------------------------- 4 new users initiated a Cart creation ------------------------------------------------------------------------------------------
-- Update the Cart Table with the new Cart session Details.
-- Cart ID got Auto Incremented for the new entry in the database
INSERT INTO Cart (CartID, CreatedBy, CreationDate)
SELECT 
   'CART' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(CartID, 5))) + 1, 'FM000'),
   'CUST011',  -- Newly added customer
   SYSTIMESTAMP 
FROM Cart;
 
INSERT INTO Cart (CartID, CreatedBy, CreationDate)
SELECT 
   'CART' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(CartID, 5))) + 1, 'FM000'),
   'CUST001',  -- Existing customer
   SYSTIMESTAMP
FROM Cart;

INSERT INTO Cart (CartID, CreatedBy, CreationDate)
SELECT 
   'CART' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(CartID, 5))) + 1, 'FM000'),
   'CUST003',  -- Existing customer
   SYSTIMESTAMP 
FROM Cart;
 
INSERT INTO Cart (CartID, CreatedBy, CreationDate)
SELECT 
   'CART' || TO_CHAR(MAX(TO_NUMBER(SUBSTR(CartID, 5))) + 1, 'FM000'),
   'CUST012',  -- New customer
   SYSTIMESTAMP
FROM Cart;
COMMIT;

------------------------------------------------------------ Analysis -------------------------------------------------------------------------------
    
-- -------------------------------
-- 1. Total Revenue per Restaurant
-- -------------------------------
SELECT 
    r.RName AS Restaurant_Name,
    SUM(o.TotalAmount) AS Total_Revenue
FROM 
    Orders o
JOIN 
    Restaurants r ON o.RestaurantID = r.RestaurantID
GROUP BY 
    r.RName
ORDER BY 
    Total_Revenue DESC;

-- -------------------------------
-- 2. Most Popular Items by Quantity Sold
-- -------------------------------
SELECT 
    i.ItemName,
    SUM(cd.Quantity) AS Total_Quantity_Sold
FROM 
    CartDetails cd
JOIN 
    Items i ON cd.MenuID = i.MenuID AND cd.ItemID = i.ItemID
GROUP BY 
    i.ItemName
ORDER BY 
    Total_Quantity_Sold DESC;

-- -------------------------------
-- 3. Average Order Value per Customer
-- -------------------------------
SELECT 
    c.Name AS Customer_Name,
    AVG(o.TotalAmount) AS Average_Spend
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.Name
ORDER BY 
    Average_Spend DESC;

-- -------------------------------
-- 4. Top 5 Customers Who Spend the Most
-- -------------------------------
SELECT 
    c.Name AS Customer_Name,
    SUM(o.TotalAmount) AS Total_Spent
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.Name
ORDER BY 
    Total_Spent DESC
FETCH FIRST 5 ROWS ONLY;

-- -------------------------------
-- 5. Orders with Discounts Applied vs. No Discount
-- -------------------------------
SELECT 
    CASE 
        WHEN o.DiscountApplied > 0 THEN 'With Discount'
        ELSE 'No Discount'
    END AS Discount_Status,
    SUM(o.TotalAmount) AS Total_Revenue
FROM 
    Orders o
GROUP BY 
    CASE 
        WHEN o.DiscountApplied > 0 THEN 'With Discount'
        ELSE 'No Discount'
    END;

-- -------------------------------
-- 6. Average Rating of Restaurants by Customers
-- -------------------------------
SELECT 
    r.RName AS Restaurant_Name,
    AVG(o.RestaurantReview) AS Average_Rating
FROM 
    Orders o
JOIN 
    Restaurants r ON o.RestaurantID = r.RestaurantID
WHERE 
    o.RestaurantReview IS NOT NULL
GROUP BY 
    r.RName
ORDER BY 
    Average_Rating DESC;

-- -------------------------------
-- 7. Promocodes Used Most Frequently
-- -------------------------------
SELECT 
    p.PromoCode AS PromoCode,
    COUNT(rp.OfferID) AS PromoCode_Usage_Count
FROM 
    RestaurantPromocodeRelation rp
JOIN 
    Promocodes p ON rp.PromoCodeID = p.PromoCodeID
GROUP BY 
    p.PromoCode
ORDER BY 
    PromoCode_Usage_Count DESC;

-- -------------------------------
-- 8. Most Ordered Items by Menu Type
-- -------------------------------
SELECT 
    m.Menutype AS Menu_Type,
    i.ItemName AS Item_Name,
    SUM(cd.Quantity) AS Total_Quantity_Sold
FROM 
    CartDetails cd
JOIN 
    Items i ON cd.MenuID = i.MenuID AND cd.ItemID = i.ItemID
JOIN 
    Menu m ON i.MenuID = m.MenuID
GROUP BY 
    m.Menutype, i.ItemName
ORDER BY 
    Menu_Type, Total_Quantity_Sold DESC;

-- -------------------------------
-- 9. Total Revenue by Payment Method
-- -------------------------------
SELECT 
    pt.PaymentMethod AS Payment_Type,
    SUM(o.TotalAmount) AS Total_Revenue
FROM 
    Orders o
JOIN 
    PaymentTypes pt ON o.PaymentTypeID = pt.PaymentTypeID
GROUP BY 
    pt.PaymentMethod
ORDER BY 
    Total_Revenue DESC;

-- -------------------------------
-- 10. Customers with Total Spend Above Average (Using Subquery)
-- -------------------------------
SELECT 
    c.Name AS Customer_Name,
    SUM(o.TotalAmount) AS Total_Spent
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.Name
HAVING 
    SUM(o.TotalAmount) > (
        SELECT AVG(TotalAmount) FROM Orders
    )
ORDER BY 
    Total_Spent DESC;

-- -------------------------------
-- 11. Customers Who Have Never Placed an Order
-- -------------------------------
SELECT 
    c.CustomerID, 
    c.Name 
FROM 
    Customers c
WHERE 
    NOT EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID);

-- -------------------------------
-- 12. Highest Discount Applied to Any Order
-- -------------------------------
SELECT 
    o.OrderID,
    o.RestaurantID,
    o.DiscountApplied
FROM 
    Orders o
WHERE 
    o.DiscountApplied = (SELECT MAX(DiscountApplied) FROM Orders);

-- -------------------------------
-- 13. Number of Orders Placed Each Day
-- -------------------------------
SELECT 
    TRUNC(o.OrderDate) AS Order_Date,
    COUNT(o.OrderID) AS Number_of_Orders
FROM 
    Orders o
GROUP BY 
    TRUNC(o.OrderDate)
ORDER BY 
    Order_Date;

-- -------------------------------
-- 14. Total Revenue per Month
-- -------------------------------
SELECT 
    TO_CHAR(o.OrderDate, 'YYYY-MM') AS Month,
    SUM(o.TotalAmount) AS Total_Revenue
FROM 
    Orders o
GROUP BY 
    TO_CHAR(o.OrderDate, 'YYYY-MM')
ORDER BY 
    Month;

-- -------------------------------
-- 15. Total Number of Cart Items Added by Each Customer
-- -------------------------------
SELECT 
    cd.AddedBy AS CustomerID,
    COUNT(cd.ItemID) AS Total_Items_Added
FROM 
    CartDetails cd
GROUP BY 
    cd.AddedBy;

-- -------------------------------
-- 16. Orders with Maximum and Minimum Total Amount
-- -------------------------------
SELECT 
    'Max' AS Order_Type,
    o.OrderID,
    o.TotalAmount
FROM 
    Orders o
WHERE 
    o.TotalAmount = (SELECT MAX(TotalAmount) FROM Orders)
UNION ALL
SELECT 
    'Min' AS Order_Type,
    o.OrderID,
    o.TotalAmount
FROM 
    Orders o
WHERE 
    o.TotalAmount = (SELECT MIN(TotalAmount) FROM Orders); 
    

--------------------------------------------------------------------------------- END ---------------------------------------------------------------------------

