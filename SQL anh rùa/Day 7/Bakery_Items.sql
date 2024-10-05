
CREATE TABLE bakery_items (
    product_name VARCHAR(255)
);

INSERT INTO bakery_items (product_name) VALUES
('Double Chocolate Doughnut'),
('Sweet Loaf'),
('Croissant'),
('Chocolate Banana Muffin'),
('Glazed Doughnut'),
('Cinnamon Roll'),
('Cheese Danish'),
('Peanut Butter Chocolate Pound Cake'),
('Fruit Tart');

SELECT * 
FROM bakery_items
WHERE LOCATE('Chocolate', product_name);