#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  インプレスジャパン発行
#  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
#  サンプルコード
#
import webapp2
from apns import APNs, Payload

apns = APNs(use_sandbox=True, cert_file='cert.pem', key_file='key.pem')
token_hex = '29c5f〜各自の環境に合わせて下さい〜f3b18e'

class MainHandler(webapp2.RequestHandler):
    def get(self):
        payload = Payload(alert=self.request.query_string, content=0)
        apns.gateway_server.send_notification(token_hex, payload)
        self.response.write("送ったよ。")

app = webapp2.WSGIApplication([('/', MainHandler)], debug=True)
