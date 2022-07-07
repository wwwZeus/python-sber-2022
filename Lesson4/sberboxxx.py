class SberBox:
    
    def __init__(self):
        self.status = 'on'
        self.film = None
        
    def turn_on_okko(self, film):
        self.film = film
        self.status_okko = 'on'
    
    def turn_off_okko(self):
        self.status_okko  = 'off'
        self.film = None
        
    def load_data(self):
        self.data = pd.read_csv(url)
        
    def __str__(self):
        return f"Status: {self.status_okko}, Film : {self.film}"
