import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE = __ENV.BASE || 'http://localhost:8000';

export const options = {
  thresholds: {
    http_req_failed: ['rate<0.05'],
    http_req_duration: ['p(95)<500'],
  },
};

export default function () {
  const statusRes = http.get(`${BASE}/status`);
  check(statusRes, {
    'status 200': (r) => r.status === 200,
    'status ok': (r) => r.json('ok') === true,
  });

  const featuresRes = http.get(`${BASE}/features`);
  check(featuresRes, {
    'features 200': (r) => r.status === 200,
  });

  const attemptPayload = JSON.stringify({
    userId: 'k6-user',
    itemId: 'char.001',
    mode: 'practice',
    answer:
      'Trade details arrive as my hero greets Lysa, promising fair trade with colorful stories shared today.',
  });
  const attemptRes = http.post(`${BASE}/api/attempt`, attemptPayload, {
    headers: { 'Content-Type': 'application/json' },
  });
  check(attemptRes, {
    'attempt 200': (r) => r.status === 200,
  });

  sleep(1);
}
