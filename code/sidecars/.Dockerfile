# Build the API application
FROM golang:1.22-alpine as builder-api
WORKDIR /go/app
COPY . .
RUN go build -v -o app sidecars/main.go

# Build the sidecar application
FROM golang:1.22-alpine as builder-sidecar
WORKDIR /go/app
COPY . .
RUN go build -v -o sidecar dsidecars/main.go

# Create the final image for the API application
FROM alpine as api
COPY --from=builder-api /go/app/app /app
EXPOSE 8080
CMD ["/app"]

# Create the final image for the sidecar application
FROM alpine as sidecar
COPY --from=builder-sidecar /go/app/sidecar /sidecar
EXPOSE 8081
CMD ["/sidecar"]
