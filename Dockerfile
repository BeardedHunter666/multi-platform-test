FROM quay.io/projectquay/golang:1.22 AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

COPY . .

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o app main.go

FROM quay.io/projectquay/golang:1.22

WORKDIR /app
COPY --from=builder /app/app .

CMD ["./app"]