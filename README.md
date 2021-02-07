# AstroApi

An api for [Astrot Bistrot](https://astrobistro.com).

## Exposed API

### /sign/moon

Get the Moon Zodiac sign at a specific time and location.

- `dt`: date must conform to `yyyy-MM-dd'T'HH:mm`
- `tz`: the time zone offset (in seconds) from GMT.

```
GET /sign/moon?dt=1986-10-16T14:20&tz=3600
🟢 200 OK
{ "sign": "♈︎" }
```

## Development

```shell
swift package update
swift build
swift run
```

**Tests:**

```shell
swift test
```

## Deployments

Pushing on `master` triggers a deployment to [Heroku](https://dashboard.heroku.com/apps/astrobistrot-api) and is available at [api.astrobistrot.com](https://api.astrobistrot.com).
