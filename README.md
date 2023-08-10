# `to_html`

## TBD

## Benchmark
```
$ crystal run --release benchmark/benchmark.cr                 
      ecr 848.57k (  1.18µs) (± 1.14%)  4.25kB/op         fastest
  to_html 222.15k (  4.50µs) (± 0.74%)  7.52kB/op    3.82× slower
    water  62.77k ( 15.93µs) (± 0.72%)  11.5kB/op   13.52× slower
blueprint 881.95  (  1.13ms) (±22.13%)  6.93MB/op  962.16× slower
```
