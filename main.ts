import { serve } from "https://deno.land/std/http/server.ts" 

const DEBUG = false;

function log(...args) {
  if (DEBUG) console.log(...args);
}

serve(async (req: Request) => {
  const { origin, href } = new URL(req.url);

  const keyword = "captcha";
  let targetUrl = href.slice(origin.length + 1);
  if (targetUrl.slice(0, keyword.length + 1) === keyword + "/") { 
    targetUrl = targetUrl.slice(keyword.length + 1); 
  } else {
    return await callback(req); 
  }

  let urlObj: any;
  try {
    urlObj = new URL(targetUrl);
  } catch (e) {
    log(e.message);
  }
  if (['http:', 'https:'].includes(urlObj?.protocol)) {
    return await fetch(targetUrl.href, {
      headers: req.headers,
      method: req.method,
      body: req.body
    });
  } else {
    return callback(req);
  }

}, { port: Deno.env.get("PORT") })

async function callback(req: Request) {
  const url = new URL(req.url); 
  url.host = "noiseblog.zeabur.app"; 
  try {
    return await fetch(url.toString(), req);
  } catch (e) {
    log(e.message);
    return new Response(null, {
      status: 200
    })
  }
}
