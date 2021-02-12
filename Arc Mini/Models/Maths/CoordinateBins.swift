// automatically generated by the FlatBuffers compiler, do not modify
// swiftlint:disable all
// swiftformat:disable all

import FlatBuffers

public struct CoordinateBins: FlatBufferObject {

  static func validateVersion() { FlatBuffersVersion_1_12_0() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Table

  public static func getRootAsCoordinateBins(bb: ByteBuffer) -> CoordinateBins { return CoordinateBins(Table(bb: bb, position: Int32(bb.read(def: UOffset.self, position: bb.reader)) + Int32(bb.reader))) }

  private init(_ t: Table) { _accessor = t }
  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Table(bb: bb, position: o) }

  private enum VTOFFSET: VOffset {
    case pseudoCount = 4
    case latMin = 6
    case latMax = 8
    case lonBinsCount = 10
    case lonMin = 12
    case lonMax = 14
    case latBins = 16
    var v: Int32 { Int32(self.rawValue) }
    var p: VOffset { self.rawValue }
  }

  public var pseudoCount: UInt16 { let o = _accessor.offset(VTOFFSET.pseudoCount.v); return o == 0 ? 0 : _accessor.readBuffer(of: UInt16.self, at: o) }
  public var latMin: Double { let o = _accessor.offset(VTOFFSET.latMin.v); return o == 0 ? 0.0 : _accessor.readBuffer(of: Double.self, at: o) }
  public var latMax: Double { let o = _accessor.offset(VTOFFSET.latMax.v); return o == 0 ? 0.0 : _accessor.readBuffer(of: Double.self, at: o) }
  public var lonBinsCount: UInt16 { let o = _accessor.offset(VTOFFSET.lonBinsCount.v); return o == 0 ? 0 : _accessor.readBuffer(of: UInt16.self, at: o) }
  public var lonMin: Double { let o = _accessor.offset(VTOFFSET.lonMin.v); return o == 0 ? 0.0 : _accessor.readBuffer(of: Double.self, at: o) }
  public var lonMax: Double { let o = _accessor.offset(VTOFFSET.lonMax.v); return o == 0 ? 0.0 : _accessor.readBuffer(of: Double.self, at: o) }
  public var latBinsCount: Int32 { let o = _accessor.offset(VTOFFSET.latBins.v); return o == 0 ? 0 : _accessor.vector(count: o) }
  public func latBins(at index: Int32) -> BinsRow? { let o = _accessor.offset(VTOFFSET.latBins.v); return o == 0 ? nil : BinsRow(_accessor.bb, o: _accessor.indirect(_accessor.vector(at: o) + index * 4)) }
  public static func startCoordinateBins(_ fbb: inout FlatBufferBuilder) -> UOffset { fbb.startTable(with: 7) }
  public static func add(pseudoCount: UInt16, _ fbb: inout FlatBufferBuilder) { fbb.add(element: pseudoCount, def: 0, at: VTOFFSET.pseudoCount.p) }
  public static func add(latMin: Double, _ fbb: inout FlatBufferBuilder) { fbb.add(element: latMin, def: 0.0, at: VTOFFSET.latMin.p) }
  public static func add(latMax: Double, _ fbb: inout FlatBufferBuilder) { fbb.add(element: latMax, def: 0.0, at: VTOFFSET.latMax.p) }
  public static func add(lonBinsCount: UInt16, _ fbb: inout FlatBufferBuilder) { fbb.add(element: lonBinsCount, def: 0, at: VTOFFSET.lonBinsCount.p) }
  public static func add(lonMin: Double, _ fbb: inout FlatBufferBuilder) { fbb.add(element: lonMin, def: 0.0, at: VTOFFSET.lonMin.p) }
  public static func add(lonMax: Double, _ fbb: inout FlatBufferBuilder) { fbb.add(element: lonMax, def: 0.0, at: VTOFFSET.lonMax.p) }
  public static func addVectorOf(latBins: Offset<UOffset>, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: latBins, at: VTOFFSET.latBins.p) }
  public static func endCoordinateBins(_ fbb: inout FlatBufferBuilder, start: UOffset) -> Offset<UOffset> { let end = Offset<UOffset>(offset: fbb.endTable(at: start)); return end }
  public static func createCoordinateBins(
    _ fbb: inout FlatBufferBuilder,
    pseudoCount: UInt16 = 0,
    latMin: Double = 0.0,
    latMax: Double = 0.0,
    lonBinsCount: UInt16 = 0,
    lonMin: Double = 0.0,
    lonMax: Double = 0.0,
    vectorOfLatBins latBins: Offset<UOffset> = Offset()
  ) -> Offset<UOffset> {
    let __start = CoordinateBins.startCoordinateBins(&fbb)
    CoordinateBins.add(pseudoCount: pseudoCount, &fbb)
    CoordinateBins.add(latMin: latMin, &fbb)
    CoordinateBins.add(latMax: latMax, &fbb)
    CoordinateBins.add(lonBinsCount: lonBinsCount, &fbb)
    CoordinateBins.add(lonMin: lonMin, &fbb)
    CoordinateBins.add(lonMax: lonMax, &fbb)
    CoordinateBins.addVectorOf(latBins: latBins, &fbb)
    return CoordinateBins.endCoordinateBins(&fbb, start: __start)
  }
}

public struct BinsRow: FlatBufferObject {

  static func validateVersion() { FlatBuffersVersion_1_12_0() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Table

  public static func getRootAsBinsRow(bb: ByteBuffer) -> BinsRow { return BinsRow(Table(bb: bb, position: Int32(bb.read(def: UOffset.self, position: bb.reader)) + Int32(bb.reader))) }

  private init(_ t: Table) { _accessor = t }
  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Table(bb: bb, position: o) }

  private enum VTOFFSET: VOffset {
    case lonBins = 4
    var v: Int32 { Int32(self.rawValue) }
    var p: VOffset { self.rawValue }
  }

  public var lonBinsCount: Int32 { let o = _accessor.offset(VTOFFSET.lonBins.v); return o == 0 ? 0 : _accessor.vector(count: o) }
  public func lonBins(at index: Int32) -> UInt16 { let o = _accessor.offset(VTOFFSET.lonBins.v); return o == 0 ? 0 : _accessor.directRead(of: UInt16.self, offset: _accessor.vector(at: o) + index * 2) }
  public var lonBins: [UInt16] { return _accessor.getVector(at: VTOFFSET.lonBins.v) ?? [] }
  public static func startBinsRow(_ fbb: inout FlatBufferBuilder) -> UOffset { fbb.startTable(with: 1) }
  public static func addVectorOf(lonBins: Offset<UOffset>, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: lonBins, at: VTOFFSET.lonBins.p) }
  public static func endBinsRow(_ fbb: inout FlatBufferBuilder, start: UOffset) -> Offset<UOffset> { let end = Offset<UOffset>(offset: fbb.endTable(at: start)); return end }
  public static func createBinsRow(
    _ fbb: inout FlatBufferBuilder,
    vectorOfLonBins lonBins: Offset<UOffset> = Offset()
  ) -> Offset<UOffset> {
    let __start = BinsRow.startBinsRow(&fbb)
    BinsRow.addVectorOf(lonBins: lonBins, &fbb)
    return BinsRow.endBinsRow(&fbb, start: __start)
  }
}

