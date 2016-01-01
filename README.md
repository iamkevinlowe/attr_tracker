# AttrTracker
Allows tracking of changes to an attribute.

Suppose you need to track the changes to the price of a product.  Each update to the price (or any tracked attribute) creates a new instance of `AttrTracker::Changes`.  Calling `product.price_changes` returns all of the price changes for the product.

## Getting Started
Add AttrTracker to your Gemfile:
```ruby
gem 'attr_tracker', github: 'iamkevinlowe/attr_tracker'
```
Run `bundle install` to download and install the gem, then `rake db:migrate` to set up AttrTracker's tables.

*Note: Reset your server if your application is currently running.*

## Usage
To start tracking an attribute, add the following to your model's class:
```ruby
class Product
  tracks :price # accepts any number of valid attributes
end
```

#### Class Methods
AttrTracker adds a class method to return all attributes of the class that are currently tracked.  
- **::tracked** - Returns an array of the tracked attributes.
    
  ```ruby
  Product.tracked => [:price]
  ```

#### Instance Methods
AttrTracker adds methods to an instance of a class to retrieve its changes.
- **#{attribute}_changes** - Returns all `AttrTracker::Changes` of an attribute
  
  ```ruby
  eggs.price_changes => [{before: 2.50, after: 2.75, created_at: 2014-10-15},
                         {before: 2.75, after: 2.99, created_at: 2014-10-31},
                         {before: 2.99, after: 3.25, created_at: 2014-11-01},
                         {before: 3.25, after: 3.50, created_at: 2014-11-15}]
  ```
- **#{attribute}_at(date)** - Returns the most recent `AttrTracker::Change` before the given date.

  ```ruby
  eggs.price_at("2014-10-31") => {before: 2.75, after: 2.99, created_at: 2014-10-31}
  ```
- **#{attribute}_between(start_date, end_date)** - Returns the `AttrTracker::Changes` between the given dates

  ```ruby
  eggs.price_between("2014-10-30", "2014-11-02") => [{before: 2.75, after: 2.99, created_at: 2014-10-31},
                                                     {before: 2.99, after: 3.25, created_at: 2014-11-01}]
  ```