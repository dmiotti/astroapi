# AstroApi

An api for [Astrot Bistrot](https://astrobistro.com).

## Exposed API

### /planets/moon

Get the Moon Zodiac sign and degree at a specific time and location.

- `dt`: date must conform to `yyyy-MM-dd'T'HH:mm`
- `tz`: the time zone offset (in seconds) from GMT.

```
GET /planets/moon?dt=1986-10-16T14:20&tz=3600
🟢 200 OK
{ "sign": "♈︎", "degree": 8.1674625375063883 }
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
