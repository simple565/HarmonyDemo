
export default interface CookieJar {
  saveFromResponse(url: string, cookies: string): void

  loadForRequest(url: string): string
}
