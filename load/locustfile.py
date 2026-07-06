"""Locust 壓測腳本（對象：restful-booker 練習服務）。

執行方式（repo root）：
  有 UI：    locust -f load/locustfile.py --host https://restful-booker.herokuapp.com
  無 UI：    locust -f load/locustfile.py --host https://restful-booker.herokuapp.com \
                 --headless -u 5 -r 1 -t 1m --html results/locust_report.html

注意：目標是公開練習服務，不是我們的資產——維持低併發（預設建議 -u 5 以下），
wait_time 不要拿掉。真實壓測請換成自家測試環境的 host。
"""

from locust import HttpUser, task, between


class BookingUser(HttpUser):
    # 每個 virtual user 在兩個動作之間隨機等 1~3 秒，模擬真實使用節奏
    wait_time = between(1, 3)

    @task(3)
    def health_check(self):
        # restful-booker 的 /ping 以 201 代表存活
        with self.client.get("/ping", catch_response=True) as resp:
            if resp.status_code == 201:
                resp.success()
            else:
                resp.failure(f"unexpected status {resp.status_code}")

    @task(2)
    def list_bookings(self):
        self.client.get("/booking")

    @task(1)
    def create_booking(self):
        payload = {
            "firstname": "Load",
            "lastname": "Test",
            "totalprice": 100,
            "depositpaid": True,
            "bookingdates": {"checkin": "2026-08-01", "checkout": "2026-08-05"},
        }
        self.client.post("/booking", json=payload)
