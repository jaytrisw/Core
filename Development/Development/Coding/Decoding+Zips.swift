import Foundation

// MARK: - Zip
public func zip<A, B>(
    _ a: Decoding<A>,
    _ b: Decoding<B>) -> Decoding<Zip2<A, B>> {
        return Decoding { decoder in
            try Zip2(
                first: a.decode(decoder),
                second: b.decode(decoder))
        }
    }

public func zip<A, B, C>(
    _ a: Decoding<A>,
    _ b: Decoding<B>,
    _ c: Decoding<C>) -> Decoding<Zip3<A, B, C>> {
        let zip2 = zip(a, b)
        return zip(zip2, c)
            .map { zipped, last in
                Zip3(
                    first: zipped.first,
                    second: zipped.second,
                    third: last)
            }
    }

public func zip<A, B, C, D>(
    _ a: Decoding<A>,
    _ b: Decoding<B>,
    _ c: Decoding<C>,
    _ d: Decoding<D>) -> Decoding<Zip4<A, B, C, D>> {
        let zip3 = zip(a, b, c)
        return zip(zip3, d)
            .map { zipped, last in
                Zip4(
                    first: zipped.first,
                    second: zipped.second,
                    third: zipped.third,
                    fourth: last)
            }
    }

public func zip<A, B, C, D, E>(
    _ a: Decoding<A>,
    _ b: Decoding<B>,
    _ c: Decoding<C>,
    _ d: Decoding<D>,
    _ e: Decoding<E>) -> Decoding<Zip5<A, B, C, D, E>> {
        let zip4 = zip(a, b, c, d)
        return zip(zip4, e)
            .map { zipped, last in
                Zip5(
                    first: zipped.first,
                    second: zipped.second,
                    third: zipped.third,
                    fourth: zipped.fourth,
                    fifth: last)
            }
    }

public func zip<A, B, C, D, E, F>(
    _ a: Decoding<A>,
    _ b: Decoding<B>,
    _ c: Decoding<C>,
    _ d: Decoding<D>,
    _ e: Decoding<E>,
    _ f: Decoding<F>) -> Decoding<Zip6<A, B, C, D, E, F>> {
        let zip5 = zip(a, b, c, d, e)
        return zip(zip5, f)
            .map { zipped, last in
                Zip6(
                    first: zipped.first,
                    second: zipped.second,
                    third: zipped.third,
                    fourth: zipped.fourth,
                    fifth: zipped.fifth,
                    sixth: last)
            }
    }

public func zip<A, B, C, D, E, F, G>(
    _ a: Decoding<A>,
    _ b: Decoding<B>,
    _ c: Decoding<C>,
    _ d: Decoding<D>,
    _ e: Decoding<E>,
    _ f: Decoding<F>,
    _ g: Decoding<G>) -> Decoding<Zip7<A, B, C, D, E, F, G>> {
        let zip6 = zip(a, b, c, d, e, f)
        return zip(zip6, g)
            .map { zipped, last in
                Zip7(
                    first: zipped.first,
                    second: zipped.second,
                    third: zipped.third,
                    fourth: zipped.fourth,
                    fifth: zipped.fifth,
                    sixth: zipped.sixth,
                    seventh: last)
            }
    }

public func zip<A, B, C, D, E, F, G, H>(
    _ a: Decoding<A>,
    _ b: Decoding<B>,
    _ c: Decoding<C>,
    _ d: Decoding<D>,
    _ e: Decoding<E>,
    _ f: Decoding<F>,
    _ g: Decoding<G>,
    _ h: Decoding<H>) -> Decoding<Zip8<A, B, C, D, E, F, G, H>> {
        let zip7 = zip(a, b, c, d, e, f, g)
        return zip(zip7, h)
            .map { zipped, last in
                Zip8(
                    first: zipped.first,
                    second: zipped.second,
                    third: zipped.third,
                    fourth: zipped.fourth,
                    fifth: zipped.fifth,
                    sixth: zipped.sixth,
                    seventh: zipped.seventh,
                    eighth: last)
            }
    }

public func zip<A, B, C, D, E, F, G, H, I>(
    _ a: Decoding<A>,
    _ b: Decoding<B>,
    _ c: Decoding<C>,
    _ d: Decoding<D>,
    _ e: Decoding<E>,
    _ f: Decoding<F>,
    _ g: Decoding<G>,
    _ h: Decoding<H>,
    _ i: Decoding<I>) -> Decoding<Zip9<A, B, C, D, E, F, G, H, I>> {
        let zip8 = zip(a, b, c, d, e, f, g, h)
        return zip(zip8, i)
            .map { zipped, last in
                Zip9(
                    first: zipped.first,
                    second: zipped.second,
                    third: zipped.third,
                    fourth: zipped.fourth,
                    fifth: zipped.fifth,
                    sixth: zipped.sixth,
                    seventh: zipped.seventh,
                    eighth: zipped.eighth,
                    ninth: last)
            }
    }

public typealias Zip2<A, B> = (first: A, second: B)
public typealias Zip3<A, B, C> = (first: A, second: B, third: C)
public typealias Zip4<A, B, C, D> = (first: A, second: B, third: C, fourth: D)
public typealias Zip5<A, B, C, D, E> = (first: A, second: B, third: C, fourth: D, fifth: E)
public typealias Zip6<A, B, C, D, E, F> = (first: A, second: B, third: C, fourth: D, fifth: E, sixth: F)
public typealias Zip7<A, B, C, D, E, F, G> = (first: A, second: B, third: C, fourth: D, fifth: E, sixth: F, seventh: G)
public typealias Zip8<A, B, C, D, E, F, G, H> = (first: A, second: B, third: C, fourth: D, fifth: E, sixth: F, seventh: G, eighth: H)
public typealias Zip9<A, B, C, D, E, F, G, H, I> = (first: A, second: B, third: C, fourth: D, fifth: E, sixth: F, seventh: G, eighth: H, ninth: I)
