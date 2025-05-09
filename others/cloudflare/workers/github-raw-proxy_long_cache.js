/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run "npm run dev" in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run "npm run deploy" to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

// Cloudflare Workers GitHub RAW 反代脚本
// 访问    https://ok.1357810.xyz/blackmatrix7/ios_rule_script/master/rule/QuantumultX/GitHub/GitHub.list
// 实际访问 https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/QuantumultX/GitHub/GitHub.list
export default {
    async fetch(request, env, ctx) {
        // 从请求中获取路径
        const url = new URL(request.url)
        const path = url.pathname.slice(1) // 去掉开头的 '/'
        // 如果路径为空，返回提示
        if (!path) {
            return new Response("Usage: /<owner>/<repo>/<branch>/path/to/file", {status: 400})
        }
        if (request.method !== "GET") {
            return new Response("method must be get", {status: 500})
        }

        const segments = path.split('/')

        // 参数校验，至少得有 用户名/仓库/分支 三段
        if (segments.length < 3) {
            return new Response('Invalid path. Use: /user/repo/branch/path...', {status: 400})
        }

        // 提取 user/repo/branch/...
        const [user, repo, branch, ...filePath] = segments

        // 构造 GitHub Raw URL
        const rawUrl = `https://raw.githubusercontent.com/${user}/${repo}/${branch}/${filePath.join('/')}`

        // 复制原始请求头,设置浏览器模拟头，避免被识别为爬虫
        let newHeaders = new Headers(request.headers)
        newHeaders.set('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36')
        newHeaders.set('Referer', 'https://github.com/')
        newHeaders.set('Accept', '*/*')

        // 构造缓存 key
        const cache = caches.default
        // 构造缓存键
        const cacheKey = request
        // 尝试读取缓存
        const cachedResponse = await cache.match(cacheKey)
        if (cachedResponse) {
            return cachedResponse
        }


        // 第一次尝试直接请求 GitHub Raw
        console.log('Github Requesting:', rawUrl)
        let response = await fetch(rawUrl, {
            method: 'GET',
            headers: newHeaders,
            redirect: 'follow'
        })

        // 如果返回 429（限速），则切换到 jsDelivr
        if (response.status === 429) {
            newHeaders.delete('Referer')
            const jsdelivrUrl = `https://cdn.jsdelivr.net/gh/${user}/${repo}@${branch}/${filePath.join('/')}`
            console.log('Fallback to:', jsdelivrUrl)
            response = await fetch(jsdelivrUrl, {
                method: 'GET',
                headers: newHeaders,
                redirect: 'follow'
            })
        }

        // 设置响应头，允许跨域
        let resHeaders = new Headers(response.headers)
        resHeaders.set('Access-Control-Allow-Origin', '*')
        resHeaders.set('Access-Control-Expose-Headers', '*')
        // 删除 CSP 相关限制头
        resHeaders.delete("content-security-policy")
        resHeaders.delete("content-security-policy-report-only")
        resHeaders.delete("clear-site-data")
        // 设置缓存时间为30天,会同时影响浏览器缓存和caches.default
        resHeaders.set('Cache-Control', 'public, max-age=2592000')

        const finalResponse = new Response(response.body, {
            status: response.status,
            headers: resHeaders
        })

        // 只有状态码为 200 时，才异步写入缓存
        if (response.status === 200) {
            ctx.waitUntil(cache.put(cacheKey, finalResponse.clone()))
        }

        // 返回
        return finalResponse
    }
}
