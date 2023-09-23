The Observer Pattern is a behavioral design pattern used in software development to establish a one-to-many dependency between objects. In this pattern, one object (called the subject) maintains a list of dependent objects (observers) that are notified when the subject's state changes. This allows the observers to react and update themselves when the subject changes without the subject having to know about the observers specifically.

```python
# Define the Observer interface
class Observer:
    def update(self, stock_symbol, stock_price):
        pass

# Define the Subject interface
class Subject:
    def register_observer(self, observer):
        pass
    
    def remove_observer(self, observer):
        pass
    
    def notify_observers(self):
        pass

# Concrete implementation of the Subject
class StockMarket(Subject):
    def __init__(self):
        self.observers = []
        self.stock_data = {}
        
    def register_observer(self, observer):
        self.observers.append(observer)
        
    def remove_observer(self, observer):
        self.observers.remove(observer)
        
    def notify_observers(self):
        for observer in self.observers:
            observer.update(self.stock_data)
            
    def set_stock_price(self, stock_symbol, stock_price):
        self.stock_data[stock_symbol] = stock_price
        self.notify_observers()

# Concrete implementation of an Observer
class StockPriceDisplay(Observer):
    def update(self, stock_data):
        print("Stock Price Display:")
        for symbol, price in stock_data.items():
            print(f"{symbol}: {price}")

# Concrete implementation of another Observer
class StockAlert(Observer):
    def update(self, stock_data):
        for symbol, price in stock_data.items():
            if price > 200:
                print(f"Alert: {symbol} has crossed $100!")

# Main program
if __name__ == "__main__":
    stock_market = StockMarket()
    
    price_display = StockPriceDisplay()
    stock_alert = StockAlert()
    
    stock_market.register_observer(price_display)
    stock_market.register_observer(stock_alert)
    
    # Simulate stock price changes
    stock_market.set_stock_price("AAPL", 150)
    stock_market.set_stock_price("GOOGL", 2500)
    stock_market.set_stock_price("TSLA", 800)
```

