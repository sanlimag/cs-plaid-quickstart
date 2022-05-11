import time, random
from locust import HttpUser, task, between
from random import randint

USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64; rv:88.0) Gecko/20100101 Firefox/88.0",
    "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko",
]


class QuickstartUser(HttpUser):
    wait_time = between(1, 10)

    def on_start(self):
        self.headers = {"User-Agent": USER_AGENTS[random.randint(0,len(USER_AGENTS)-1)]}
        self.client.headers = self.headers

    @task(10)
    def load_page(self):
        self.client.get("")
        self.client.post("api/info")
        self.client.get("api/auth")
        self.client.get("api/accounts")
        self.client.get("api/transactions")
        self.client.get("api/balance")
        self.client.post("api/get_link_token")

    @task(1)
    def gen_errors(self):
        self.client.post("api/auth")
        self.client.get("api/info")
