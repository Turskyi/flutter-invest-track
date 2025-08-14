import 'dart:core';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'rates_response.g.dart';

@JsonSerializable(createToJson: false)
class RatesResponse implements Rates {
  factory RatesResponse.fromJson(Map<String, dynamic> json) =>
      _$RatesResponseFromJson(json);

  const RatesResponse({
    required this.cad,
    required this.pln,
    required this.usd,
    required this.uah,
    required this.eur,
    required this.aed,
    required this.afn,
    required this.all,
    required this.amd,
    required this.ang,
    required this.aoa,
    required this.ars,
    required this.aud,
    required this.awg,
    required this.azn,
    required this.bam,
    required this.bbd,
    required this.bdt,
    required this.bgn,
    required this.bhd,
    required this.bif,
    required this.bmd,
    required this.bnd,
    required this.bob,
    required this.brl,
    required this.bsd,
    required this.btn,
    required this.bwp,
    required this.byn,
    required this.bzd,
    required this.cdf,
    required this.chf,
    required this.clp,
    required this.cny,
    required this.cop,
    required this.crc,
    required this.cup,
    required this.cve,
    required this.czk,
    required this.djf,
    required this.dkk,
    required this.dop,
    required this.dzd,
    required this.egp,
    required this.ern,
    required this.etb,
    required this.fjd,
    required this.fkp,
    required this.fok,
    required this.gbp,
    required this.gel,
    required this.ggp,
    required this.ghs,
    required this.gip,
    required this.gmd,
    required this.gnf,
    required this.gtq,
    required this.gyd,
    required this.hnl,
    required this.hrk,
    required this.htg,
    required this.huf,
    required this.idr,
    required this.ils,
    required this.imp,
    required this.inr,
    required this.iqd,
    required this.irr,
    required this.isk,
    required this.jep,
    required this.jmd,
    required this.jod,
    required this.jpy,
    required this.kes,
    required this.kgs,
    required this.khr,
    required this.kid,
    required this.kmf,
    required this.krw,
    required this.kwd,
    required this.kyd,
    required this.kzt,
    required this.lak,
    required this.lbp,
    required this.lkr,
    required this.lrd,
    required this.lsl,
    required this.lyd,
    required this.mad,
    required this.mdl,
    required this.mga,
    required this.mkd,
    required this.mmk,
    required this.mnt,
    required this.mop,
    required this.mru,
    required this.mur,
    required this.mvr,
    required this.mwk,
    required this.mxn,
    required this.myr,
    required this.mzn,
    required this.nad,
    required this.ngn,
    required this.nio,
    required this.nok,
    required this.npr,
    required this.nzd,
    required this.omr,
    required this.pab,
    required this.pen,
    required this.pgk,
    required this.php,
    required this.pkr,
    required this.pyg,
    required this.qar,
    required this.ron,
    required this.rsd,
    required this.rub,
    required this.rwf,
    required this.sar,
    required this.sbd,
    required this.scr,
    required this.sdg,
    required this.sek,
    required this.sgd,
    required this.shp,
    required this.sle,
    required this.sll,
    required this.sos,
    required this.srd,
    required this.ssp,
    required this.stn,
    required this.syp,
    required this.szl,
    required this.thb,
    required this.tjs,
    required this.tmt,
    required this.tnd,
    required this.top,
    required this.ttd,
    required this.tvd,
    required this.twd,
    required this.tzs,
    required this.ugx,
    required this.uyu,
    required this.uzs,
    required this.ves,
    required this.vnd,
    required this.vuv,
    required this.wst,
    required this.xaf,
    required this.xcd,
    required this.xdr,
    required this.xof,
    required this.xpf,
    required this.yer,
    required this.zar,
    required this.zmw,
    required this.zwl,
  });

  @override
  Map<String, double> toJson() => <String, double>{
    'USD': usd,
    'CAD': cad,
    'UAH': uah,
    'EUR': eur,
    'PLN': pln,
    'AED': aed,
    'AFN': afn,
    'ALL': all,
    'AMD': amd,
    'ANG': ang,
    'AOA': aoa,
    'ARS': ars,
    'AUD': aud,
    'AWG': awg,
    'AZN': azn,
    'BAM': bam,
    'BBD': bbd,
    'BDT': bdt,
    'BGN': bgn,
    'BHD': bhd,
    'BIF': bif,
    'BMD': bmd,
    'BND': bnd,
    'BOB': bob,
    'BRL': brl,
    'BSD': bsd,
    'BTN': btn,
    'BWP': bwp,
    'BYN': byn,
    'BZD': bzd,
    'CDF': cdf,
    'CHF': chf,
    'CLP': clp,
    'CNY': cny,
    'COP': cop,
    'CRC': crc,
    'CUP': cup,
    'CVE': cve,
    'CZK': czk,
    'DJF': djf,
    'DKK': dkk,
    'DOP': dop,
    'DZD': dzd,
    'EGP': egp,
    'ERN': ern,
    'ETB': etb,
    'FJD': fjd,
    'FKP': fkp,
    'FOK': fok,
    'GBP': gbp,
    'GEL': gel,
    'GGP': ggp,
    'GHS': ghs,
    'GIP': gip,
    'GMD': gmd,
    'GNF': gnf,
    'GTQ': gtq,
    'GYD': gyd,
    'HNL': hnl,
    'HRK': hrk,
    'HTG': htg,
    'HUF': huf,
    'IDR': idr,
    'ILS': ils,
    'IMP': imp,
    'INR': inr,
    'IQD': iqd,
    'IRR': irr,
    'ISK': isk,
    'JEP': jep,
    'JMD': jmd,
    'JOD': jod,
    'JPY': jpy,
    'KES': kes,
    'KGS': kgs,
    'KHR': khr,
    'KID': kid,
    'KMF': kmf,
    'KRW': krw,
    'KWD': kwd,
    'KYD': kyd,
    'KZT': kzt,
    'LAK': lak,
    'LBP': lbp,
    'LKR': lkr,
    'LRD': lrd,
    'LSL': lsl,
    'LYD': lyd,
    'MAD': mad,
    'MDL': mdl,
    'MGA': mga,
    'MKD': mkd,
    'MMK': mmk,
    'MNT': mnt,
    'MOP': mop,
    'MRU': mru,
    'MUR': mur,
    'MVR': mvr,
    'MWK': mwk,
    'MXN': mxn,
    'MYR': myr,
    'MZN': mzn,
    'NAD': nad,
    'NGN': ngn,
    'NIO': nio,
    'NOK': nok,
    'NPR': npr,
    'NZD': nzd,
    'OMR': omr,
    'PAB': pab,
    'PEN': pen,
    'PGK': pgk,
    'PHP': php,
    'PKR': pkr,
    'PYG': pyg,
    'QAR': qar,
    'RON': ron,
    'RSD': rsd,
    'RUB': rub,
    'RWF': rwf,
    'SAR': sar,
    'SBD': sbd,
    'SCR': scr,
    'SDG': sdg,
    'SEK': sek,
    'SGD': sgd,
    'SHP': shp,
    'SLE': sle,
    'SLL': sll,
    'SOS': sos,
    'SRD': srd,
    'SSP': ssp,
    'STN': stn,
    'SYP': syp,
    'SZL': szl,
    'THB': thb,
    'TJS': tjs,
    'TMT': tmt,
    'TND': tnd,
    'TOP': top,
    'TTD': ttd,
    'TVD': tvd,
    'TWD': twd,
    'TZS': tzs,
    'UGX': ugx,
    'UYU': uyu,
    'UZS': uzs,
    'VES': ves,
    'VND': vnd,
    'VUV': vuv,
    'WST': wst,
    'XAF': xaf,
    'XCD': xcd,
    'XDR': xdr,
    'XOF': xof,
    'XPF': xpf,
    'YER': yer,
    'ZAR': zar,
    'ZMW': zmw,
    'ZWL': zwl,
  };

  @override
  @JsonKey(name: 'CAD')
  final double cad;

  @override
  @JsonKey(name: 'USD')
  final double usd;

  @override
  @JsonKey(name: 'UAH')
  final double uah;

  @override
  @JsonKey(name: 'EUR')
  final double eur;

  @override
  @JsonKey(name: 'PLN')
  final double pln;
  @override
  @JsonKey(name: 'AED')
  final double aed;
  @override
  @JsonKey(name: 'AFN')
  final double afn;
  @override
  @JsonKey(name: 'ALL')
  final double all;
  @override
  @JsonKey(name: 'AMD')
  final double amd;
  @override
  @JsonKey(name: 'ANG')
  final double ang;
  @override
  @JsonKey(name: 'AOA')
  final double aoa;
  @override
  @JsonKey(name: 'ARS')
  final double ars;
  @override
  @JsonKey(name: 'AUD')
  final double aud;
  @override
  @JsonKey(name: 'AWG')
  final double awg;
  @override
  @JsonKey(name: 'AZN')
  final double azn;
  @override
  @JsonKey(name: 'BAM')
  final double bam;
  @override
  @JsonKey(name: 'BBD')
  final double bbd;
  @override
  @JsonKey(name: 'BDT')
  final double bdt;
  @override
  @JsonKey(name: 'BGN')
  final double bgn;
  @override
  @JsonKey(name: 'BHD')
  final double bhd;
  @override
  @JsonKey(name: 'BIF')
  final double bif;
  @override
  @JsonKey(name: 'BMD')
  final double bmd;
  @override
  @JsonKey(name: 'BND')
  final double bnd;
  @override
  @JsonKey(name: 'BOB')
  final double bob;
  @override
  @JsonKey(name: 'BRL')
  final double brl;
  @override
  @JsonKey(name: 'BSD')
  final double bsd;
  @override
  @JsonKey(name: 'BTN')
  final double btn;
  @override
  @JsonKey(name: 'BWP')
  final double bwp;
  @override
  @JsonKey(name: 'BYN')
  final double byn;
  @override
  @JsonKey(name: 'BZD')
  final double bzd;
  @override
  @JsonKey(name: 'CDF')
  final double cdf;
  @override
  @JsonKey(name: 'CHF')
  final double chf;
  @override
  @JsonKey(name: 'CLP')
  final double clp;
  @override
  @JsonKey(name: 'CNY')
  final double cny;
  @override
  @JsonKey(name: 'COP')
  final double cop;
  @override
  @JsonKey(name: 'CRC')
  final double crc;
  @override
  @JsonKey(name: 'CUP')
  final double cup;
  @override
  @JsonKey(name: 'CVE')
  final double cve;
  @override
  @JsonKey(name: 'CZK')
  final double czk;
  @override
  @JsonKey(name: 'DJF')
  final double djf;
  @override
  @JsonKey(name: 'DKK')
  final double dkk;
  @override
  @JsonKey(name: 'DOP')
  final double dop;
  @override
  @JsonKey(name: 'DZD')
  final double dzd;
  @override
  @JsonKey(name: 'EGP')
  final double egp;
  @override
  @JsonKey(name: 'ERN')
  final double ern;
  @override
  @JsonKey(name: 'ETB')
  final double etb;
  @override
  @JsonKey(name: 'FJD')
  final double fjd;
  @override
  @JsonKey(name: 'FKP')
  final double fkp;
  @override
  @JsonKey(name: 'FOK')
  final double fok;
  @override
  @JsonKey(name: 'GBP')
  final double gbp;
  @override
  @JsonKey(name: 'GEL')
  final double gel;
  @override
  @JsonKey(name: 'GGP')
  final double ggp;
  @override
  @JsonKey(name: 'GHS')
  final double ghs;
  @override
  @JsonKey(name: 'GIP')
  final double gip;
  @override
  @JsonKey(name: 'GMD')
  final double gmd;
  @override
  @JsonKey(name: 'GNF')
  final double gnf;
  @override
  @JsonKey(name: 'GTQ')
  final double gtq;
  @override
  @JsonKey(name: 'GYD')
  final double gyd;
  @override
  @JsonKey(name: 'HNL')
  final double hnl;
  @override
  @JsonKey(name: 'HRK')
  final double hrk;
  @override
  @JsonKey(name: 'HTG')
  final double htg;
  @override
  @JsonKey(name: 'HUF')
  final double huf;
  @override
  @JsonKey(name: 'IDR')
  final double idr;
  @override
  @JsonKey(name: 'ILS')
  final double ils;
  @override
  @JsonKey(name: 'IMP')
  final double imp;
  @override
  @JsonKey(name: 'INR')
  final double inr;
  @override
  @JsonKey(name: 'IQD')
  final double iqd;
  @override
  @JsonKey(name: 'IRR')
  final double irr;
  @override
  @JsonKey(name: 'ISK')
  final double isk;
  @override
  @JsonKey(name: 'JEP')
  final double jep;
  @override
  @JsonKey(name: 'JMD')
  final double jmd;
  @override
  @JsonKey(name: 'JOD')
  final double jod;
  @override
  @JsonKey(name: 'JPY')
  final double jpy;
  @override
  @JsonKey(name: 'KES')
  final double kes;
  @override
  @JsonKey(name: 'KGS')
  final double kgs;
  @override
  @JsonKey(name: 'KHR')
  final double khr;
  @override
  @JsonKey(name: 'KID')
  final double kid;
  @override
  @JsonKey(name: 'KMF')
  final double kmf;
  @override
  @JsonKey(name: 'KRW')
  final double krw;
  @override
  @JsonKey(name: 'KWD')
  final double kwd;
  @override
  @JsonKey(name: 'KYD')
  final double kyd;
  @override
  @JsonKey(name: 'KZT')
  final double kzt;
  @override
  @JsonKey(name: 'LAK')
  final double lak;
  @override
  @JsonKey(name: 'LBP')
  final double lbp;
  @override
  @JsonKey(name: 'LKR')
  final double lkr;
  @override
  @JsonKey(name: 'LRD')
  final double lrd;
  @override
  @JsonKey(name: 'LSL')
  final double lsl;
  @override
  @JsonKey(name: 'LYD')
  final double lyd;
  @override
  @JsonKey(name: 'MAD')
  final double mad;
  @override
  @JsonKey(name: 'MDL')
  final double mdl;
  @override
  @JsonKey(name: 'MGA')
  final double mga;
  @override
  @JsonKey(name: 'MKD')
  final double mkd;
  @override
  @JsonKey(name: 'MMK')
  final double mmk;
  @override
  @JsonKey(name: 'MNT')
  final double mnt;
  @override
  @JsonKey(name: 'MOP')
  final double mop;
  @override
  @JsonKey(name: 'MRU')
  final double mru;
  @override
  @JsonKey(name: 'MUR')
  final double mur;
  @override
  @JsonKey(name: 'MVR')
  final double mvr;
  @override
  @JsonKey(name: 'MWK')
  final double mwk;
  @override
  @JsonKey(name: 'MXN')
  final double mxn;
  @override
  @JsonKey(name: 'MYR')
  final double myr;
  @override
  @JsonKey(name: 'MZN')
  final double mzn;
  @override
  @JsonKey(name: 'NAD')
  final double nad;
  @override
  @JsonKey(name: 'NGN')
  final double ngn;
  @override
  @JsonKey(name: 'NIO')
  final double nio;
  @override
  @JsonKey(name: 'NOK')
  final double nok;
  @override
  @JsonKey(name: 'NPR')
  final double npr;
  @override
  @JsonKey(name: 'NZD')
  final double nzd;
  @override
  @JsonKey(name: 'OMR')
  final double omr;
  @override
  @JsonKey(name: 'PAB')
  final double pab;
  @override
  @JsonKey(name: 'PEN')
  final double pen;
  @override
  @JsonKey(name: 'PGK')
  final double pgk;
  @override
  @JsonKey(name: 'PHP')
  final double php;
  @override
  @JsonKey(name: 'PKR')
  final double pkr;
  @override
  @JsonKey(name: 'PYG')
  final double pyg;
  @override
  @JsonKey(name: 'QAR')
  final double qar;
  @override
  @JsonKey(name: 'RON')
  final double ron;
  @override
  @JsonKey(name: 'RSD')
  final double rsd;
  @override
  @JsonKey(name: 'RUB')
  final double rub;
  @override
  @JsonKey(name: 'RWF')
  final double rwf;
  @override
  @JsonKey(name: 'SAR')
  final double sar;
  @override
  @JsonKey(name: 'SBD')
  final double sbd;
  @override
  @JsonKey(name: 'SCR')
  final double scr;
  @override
  @JsonKey(name: 'SDG')
  final double sdg;
  @override
  @JsonKey(name: 'SEK')
  final double sek;
  @override
  @JsonKey(name: 'SGD')
  final double sgd;
  @override
  @JsonKey(name: 'SHP')
  final double shp;
  @override
  @JsonKey(name: 'SLE')
  final double sle;
  @override
  @JsonKey(name: 'SLL')
  final double sll;
  @override
  @JsonKey(name: 'SOS')
  final double sos;
  @override
  @JsonKey(name: 'SRD')
  final double srd;
  @override
  @JsonKey(name: 'SSP')
  final double ssp;
  @override
  @JsonKey(name: 'STN')
  final double stn;
  @override
  @JsonKey(name: 'SYP')
  final double syp;
  @override
  @JsonKey(name: 'SZL')
  final double szl;
  @override
  @JsonKey(name: 'THB')
  final double thb;
  @override
  @JsonKey(name: 'TJS')
  final double tjs;
  @override
  @JsonKey(name: 'TMT')
  final double tmt;
  @override
  @JsonKey(name: 'TND')
  final double tnd;
  @override
  @JsonKey(name: 'TOP')
  final double top;
  @override
  @JsonKey(name: 'TTD')
  final double ttd;
  @override
  @JsonKey(name: 'TVD')
  final double tvd;
  @override
  @JsonKey(name: 'TWD')
  final double twd;
  @override
  @JsonKey(name: 'TZS')
  final double tzs;
  @override
  @JsonKey(name: 'UGX')
  final double ugx;
  @override
  @JsonKey(name: 'UYU')
  final double uyu;
  @override
  @JsonKey(name: 'UZS')
  final double uzs;
  @override
  @JsonKey(name: 'VES')
  final double ves;
  @override
  @JsonKey(name: 'VND')
  final double vnd;
  @override
  @JsonKey(name: 'VUV')
  final double vuv;
  @override
  @JsonKey(name: 'WST')
  final double wst;
  @override
  @JsonKey(name: 'XAF')
  final double xaf;
  @override
  @JsonKey(name: 'XCD')
  final double xcd;
  @override
  @JsonKey(name: 'XDR')
  final double xdr;
  @override
  @JsonKey(name: 'XOF')
  final double xof;
  @override
  @JsonKey(name: 'XPF')
  final double xpf;
  @override
  @JsonKey(name: 'YER')
  final double yer;
  @override
  @JsonKey(name: 'ZAR')
  final double zar;
  @override
  @JsonKey(name: 'ZMW')
  final double zmw;
  @override
  @JsonKey(name: 'ZWL')
  final double zwl;

  @override
  String toString() {
    return 'RatesResponse('
        'cad: $cad, '
        'aed: $aed, '
        'afn: $afn, '
        'all: $all, '
        'amd: $amd, '
        'ang: $ang, '
        'aoa: $aoa, '
        'ars: $ars, '
        'aud: $aud, '
        'awg: $awg, '
        'azn: $azn, '
        'bam: $bam, '
        'bbd: $bbd, '
        'bdt: $bdt, '
        'bgn: $bgn, '
        'bhd: $bhd, '
        'bif: $bif, '
        'bmd: $bmd, '
        'bnd: $bnd, '
        'bob: $bob, '
        'brl: $brl, '
        'bsd: $bsd, '
        'btn: $btn, '
        'bwp: $bwp, '
        'byn: $byn, '
        'bzd: $bzd, '
        'cdf: $cdf, '
        'chf: $chf, '
        'clp: $clp, '
        'cny: $cny, '
        'cop: $cop, '
        'crc: $crc, '
        'cup: $cup, '
        'cve: $cve, '
        'czk: $czk, '
        'djf: $djf, '
        'dkk: $dkk, '
        'dop: $dop, '
        'dzd: $dzd, '
        'egp: $egp, '
        'ern: $ern, '
        'etb: $etb, '
        'eur: $eur, '
        'fjd: $fjd, '
        'fkp: $fkp, '
        'fok: $fok, '
        'gbp: $gbp, '
        'gel: $gel, '
        'ggp: $ggp, '
        'ghs: $ghs, '
        'gip: $gip, '
        'gmd: $gmd, '
        'gnf: $gnf, '
        'gtq: $gtq, '
        'gyd: $gyd, '
        'hnl: $hnl, '
        'hrk: $hrk, '
        'htg: $htg, '
        'huf: $huf, '
        'idr: $idr, '
        'ils: $ils, '
        'imp: $imp, '
        'inr: $inr, '
        'iqd: $iqd, '
        'irr: $irr, '
        'isk: $isk, '
        'jep: $jep, '
        'jmd: $jmd, '
        'jod: $jod, '
        'jpy: $jpy, '
        'kes: $kes, '
        'kgs: $kgs, '
        'khr: $khr, '
        'kid: $kid, '
        'kmf: $kmf, '
        'krw: $krw, '
        'kwd: $kwd, '
        'kyd: $kyd, '
        'kzt: $kzt, '
        'lak: $lak, '
        'lbp: $lbp, '
        'lkr: $lkr, '
        'lrd: $lrd, '
        'lsl: $lsl, '
        'lyd: $lyd, '
        'mad: $mad, '
        'mdl: $mdl, '
        'mga: $mga, '
        'mkd: $mkd, '
        'mmk: $mmk, '
        'mnt: $mnt, '
        'mop: $mop, '
        'mru: $mru, '
        'mur: $mur, '
        'mvr: $mvr, '
        'mwk: $mwk, '
        'mxn: $mxn, '
        'myr: $myr, '
        'mzn: $mzn, '
        'nad: $nad, '
        'ngn: $ngn, '
        'nio: $nio, '
        'nok: $nok, '
        'npr: $npr, '
        'nzd: $nzd, '
        'omr: $omr, '
        'pab: $pab, '
        'pen: $pen, '
        'pgk: $pgk, '
        'php: $php, '
        'pkr: $pkr, '
        'pln: $pln, '
        'pyg: $pyg, '
        'qar: $qar, '
        'ron: $ron, '
        'rsd: $rsd, '
        'rub: $rub, '
        'rwf: $rwf, '
        'sar: $sar, '
        'sbd: $sbd, '
        'scr: $scr, '
        'sdg: $sdg, '
        'sek: $sek, '
        'sgd: $sgd, '
        'shp: $shp, '
        'sle: $sle, '
        'sll: $sll, '
        'sos: $sos, '
        'srd: $srd, '
        'ssp: $ssp, '
        'stn: $stn, '
        'syp: $syp, '
        'szl: $szl, '
        'thb: $thb, '
        'tjs: $tjs, '
        'tmt: $tmt, '
        'tnd: $tnd, '
        'top: $top, '
        'ttd: $ttd, '
        'tvd: $tvd, '
        'twd: $twd, '
        'tzs: $tzs, '
        'uah: $uah, '
        'ugx: $ugx, '
        'usd: $usd, '
        'uyu: $uyu, '
        'uzs: $uzs, '
        'ves: $ves, '
        'vnd: $vnd, '
        'vuv: $vuv, '
        'wst: $wst, '
        'xaf: $xaf, '
        'xcd: $xcd, '
        'xdr: $xdr, '
        'xof: $xof, '
        'xpf: $xpf, '
        'yer: $yer, '
        'zar: $zar, '
        'zmw: $zmw, '
        'zwl: $zwl,'
        ')';
  }

  RatesResponse copyWith({
    double? cad,
    double? aed,
    double? afn,
    double? all,
    double? amd,
    double? ang,
    double? aoa,
    double? ars,
    double? aud,
    double? awg,
    double? azn,
    double? bam,
    double? bbd,
    double? bdt,
    double? bgn,
    double? bhd,
    double? bif,
    double? bmd,
    double? bnd,
    double? bob,
    double? brl,
    double? bsd,
    double? btn,
    double? bwp,
    double? byn,
    double? bzd,
    double? cdf,
    double? chf,
    double? clp,
    double? cny,
    double? cop,
    double? crc,
    double? cup,
    double? cve,
    double? czk,
    double? djf,
    double? dkk,
    double? dop,
    double? dzd,
    double? egp,
    double? ern,
    double? etb,
    double? eur,
    double? fjd,
    double? fkp,
    double? fok,
    double? gbp,
    double? gel,
    double? ggp,
    double? ghs,
    double? gip,
    double? gmd,
    double? gnf,
    double? gtq,
    double? gyd,
    double? hkd,
    double? hnl,
    double? hrk,
    double? htg,
    double? huf,
    double? idr,
    double? ils,
    double? imp,
    double? inr,
    double? iqd,
    double? irr,
    double? isk,
    double? jep,
    double? jmd,
    double? jod,
    double? jpy,
    double? kes,
    double? kgs,
    double? khr,
    double? kid,
    double? kmf,
    double? krw,
    double? kwd,
    double? kyd,
    double? kzt,
    double? lak,
    double? lbp,
    double? lkr,
    double? lrd,
    double? lsl,
    double? lyd,
    double? mad,
    double? mdl,
    double? mga,
    double? mkd,
    double? mmk,
    double? mnt,
    double? mop,
    double? mru,
    double? mur,
    double? mvr,
    double? mwk,
    double? mxn,
    double? myr,
    double? mzn,
    double? nad,
    double? ngn,
    double? nio,
    double? nok,
    double? npr,
    double? nzd,
    double? omr,
    double? pab,
    double? pen,
    double? pgk,
    double? php,
    double? pkr,
    double? pln,
    double? pyg,
    double? qar,
    double? ron,
    double? rsd,
    double? rub,
    double? rwf,
    double? sar,
    double? sbd,
    double? scr,
    double? sdg,
    double? sek,
    double? sgd,
    double? shp,
    double? sle,
    double? sll,
    double? sos,
    double? srd,
    double? ssp,
    double? stn,
    double? syp,
    double? szl,
    double? thb,
    double? tjs,
    double? tmt,
    double? tnd,
    double? top,
    double? ttd,
    double? tvd,
    double? twd,
    double? tzs,
    double? uah,
    double? ugx,
    double? usd,
    double? uyu,
    double? uzs,
    double? ves,
    double? vnd,
    double? vuv,
    double? wst,
    double? xaf,
    double? xcd,
    double? xdr,
    double? xof,
    double? xpf,
    double? yer,
    double? zar,
    double? zmw,
    double? zwl,
  }) {
    return RatesResponse(
      cad: cad ?? this.cad,
      aed: aed ?? this.aed,
      afn: afn ?? this.afn,
      all: all ?? this.all,
      amd: amd ?? this.amd,
      ang: ang ?? this.ang,
      aoa: aoa ?? this.aoa,
      ars: ars ?? this.ars,
      aud: aud ?? this.aud,
      awg: awg ?? this.awg,
      azn: azn ?? this.azn,
      bam: bam ?? this.bam,
      bbd: bbd ?? this.bbd,
      bdt: bdt ?? this.bdt,
      bgn: bgn ?? this.bgn,
      bhd: bhd ?? this.bhd,
      bif: bif ?? this.bif,
      bmd: bmd ?? this.bmd,
      bnd: bnd ?? this.bnd,
      bob: bob ?? this.bob,
      brl: brl ?? this.brl,
      bsd: bsd ?? this.bsd,
      btn: btn ?? this.btn,
      bwp: bwp ?? this.bwp,
      byn: byn ?? this.byn,
      bzd: bzd ?? this.bzd,
      cdf: cdf ?? this.cdf,
      chf: chf ?? this.chf,
      clp: clp ?? this.clp,
      cny: cny ?? this.cny,
      cop: cop ?? this.cop,
      crc: crc ?? this.crc,
      cup: cup ?? this.cup,
      cve: cve ?? this.cve,
      czk: czk ?? this.czk,
      djf: djf ?? this.djf,
      dkk: dkk ?? this.dkk,
      dop: dop ?? this.dop,
      dzd: dzd ?? this.dzd,
      egp: egp ?? this.egp,
      ern: ern ?? this.ern,
      etb: etb ?? this.etb,
      eur: eur ?? this.eur,
      fjd: fjd ?? this.fjd,
      fkp: fkp ?? this.fkp,
      fok: fok ?? this.fok,
      gbp: gbp ?? this.gbp,
      gel: gel ?? this.gel,
      ggp: ggp ?? this.ggp,
      ghs: ghs ?? this.ghs,
      gip: gip ?? this.gip,
      gmd: gmd ?? this.gmd,
      gnf: gnf ?? this.gnf,
      gtq: gtq ?? this.gtq,
      gyd: gyd ?? this.gyd,
      hnl: hnl ?? this.hnl,
      hrk: hrk ?? this.hrk,
      htg: htg ?? this.htg,
      huf: huf ?? this.huf,
      idr: idr ?? this.idr,
      ils: ils ?? this.ils,
      imp: imp ?? this.imp,
      inr: inr ?? this.inr,
      iqd: iqd ?? this.iqd,
      irr: irr ?? this.irr,
      isk: isk ?? this.isk,
      jep: jep ?? this.jep,
      jmd: jmd ?? this.jmd,
      jod: jod ?? this.jod,
      jpy: jpy ?? this.jpy,
      kes: kes ?? this.kes,
      kgs: kgs ?? this.kgs,
      khr: khr ?? this.khr,
      kid: kid ?? this.kid,
      kmf: kmf ?? this.kmf,
      krw: krw ?? this.krw,
      kwd: kwd ?? this.kwd,
      kyd: kyd ?? this.kyd,
      kzt: kzt ?? this.kzt,
      lak: lak ?? this.lak,
      lbp: lbp ?? this.lbp,
      lkr: lkr ?? this.lkr,
      lrd: lrd ?? this.lrd,
      lsl: lsl ?? this.lsl,
      lyd: lyd ?? this.lyd,
      mad: mad ?? this.mad,
      mdl: mdl ?? this.mdl,
      mga: mga ?? this.mga,
      mkd: mkd ?? this.mkd,
      mmk: mmk ?? this.mmk,
      mnt: mnt ?? this.mnt,
      mop: mop ?? this.mop,
      mru: mru ?? this.mru,
      mur: mur ?? this.mur,
      mvr: mvr ?? this.mvr,
      mwk: mwk ?? this.mwk,
      mxn: mxn ?? this.mxn,
      myr: myr ?? this.myr,
      mzn: mzn ?? this.mzn,
      nad: nad ?? this.nad,
      ngn: ngn ?? this.ngn,
      nio: nio ?? this.nio,
      nok: nok ?? this.nok,
      npr: npr ?? this.npr,
      nzd: nzd ?? this.nzd,
      omr: omr ?? this.omr,
      pab: pab ?? this.pab,
      pen: pen ?? this.pen,
      pgk: pgk ?? this.pgk,
      php: php ?? this.php,
      pkr: pkr ?? this.pkr,
      pln: pln ?? this.pln,
      pyg: pyg ?? this.pyg,
      qar: qar ?? this.qar,
      ron: ron ?? this.ron,
      rsd: rsd ?? this.rsd,
      rub: rub ?? this.rub,
      rwf: rwf ?? this.rwf,
      sar: sar ?? this.sar,
      sbd: sbd ?? this.sbd,
      scr: scr ?? this.scr,
      sdg: sdg ?? this.sdg,
      sek: sek ?? this.sek,
      sgd: sgd ?? this.sgd,
      shp: shp ?? this.shp,
      sle: sle ?? this.sle,
      sll: sll ?? this.sll,
      sos: sos ?? this.sos,
      srd: srd ?? this.srd,
      ssp: ssp ?? this.ssp,
      stn: stn ?? this.stn,
      syp: syp ?? this.syp,
      szl: szl ?? this.szl,
      thb: thb ?? this.thb,
      tjs: tjs ?? this.tjs,
      tmt: tmt ?? this.tmt,
      tnd: tnd ?? this.tnd,
      top: top ?? this.top,
      ttd: ttd ?? this.ttd,
      tvd: tvd ?? this.tvd,
      twd: twd ?? this.twd,
      tzs: tzs ?? this.tzs,
      uah: uah ?? this.uah,
      ugx: ugx ?? this.ugx,
      usd: usd ?? this.usd,
      uyu: uyu ?? this.uyu,
      uzs: uzs ?? this.uzs,
      ves: ves ?? this.ves,
      vnd: vnd ?? this.vnd,
      vuv: vuv ?? this.vuv,
      wst: wst ?? this.wst,
      xaf: xaf ?? this.xaf,
      xcd: xcd ?? this.xcd,
      xdr: xdr ?? this.xdr,
      xof: xof ?? this.xof,
      xpf: xpf ?? this.xpf,
      yer: yer ?? this.yer,
      zar: zar ?? this.zar,
      zmw: zmw ?? this.zmw,
      zwl: zwl ?? this.zwl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! RatesResponse) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      cad.hashCode ^
      aed.hashCode ^
      afn.hashCode ^
      all.hashCode ^
      amd.hashCode ^
      ang.hashCode ^
      aoa.hashCode ^
      ars.hashCode ^
      aud.hashCode ^
      awg.hashCode ^
      azn.hashCode ^
      bam.hashCode ^
      bbd.hashCode ^
      bdt.hashCode ^
      bgn.hashCode ^
      bhd.hashCode ^
      bif.hashCode ^
      bmd.hashCode ^
      bnd.hashCode ^
      bob.hashCode ^
      brl.hashCode ^
      bsd.hashCode ^
      btn.hashCode ^
      bwp.hashCode ^
      byn.hashCode ^
      bzd.hashCode ^
      cdf.hashCode ^
      chf.hashCode ^
      clp.hashCode ^
      cny.hashCode ^
      cop.hashCode ^
      crc.hashCode ^
      cup.hashCode ^
      cve.hashCode ^
      czk.hashCode ^
      djf.hashCode ^
      dkk.hashCode ^
      dop.hashCode ^
      dzd.hashCode ^
      egp.hashCode ^
      ern.hashCode ^
      etb.hashCode ^
      eur.hashCode ^
      fjd.hashCode ^
      fkp.hashCode ^
      fok.hashCode ^
      gbp.hashCode ^
      gel.hashCode ^
      ggp.hashCode ^
      ghs.hashCode ^
      gip.hashCode ^
      gmd.hashCode ^
      gnf.hashCode ^
      gtq.hashCode ^
      gyd.hashCode ^
      hnl.hashCode ^
      hrk.hashCode ^
      htg.hashCode ^
      huf.hashCode ^
      idr.hashCode ^
      ils.hashCode ^
      imp.hashCode ^
      inr.hashCode ^
      iqd.hashCode ^
      irr.hashCode ^
      isk.hashCode ^
      jep.hashCode ^
      jmd.hashCode ^
      jod.hashCode ^
      jpy.hashCode ^
      kes.hashCode ^
      kgs.hashCode ^
      khr.hashCode ^
      kid.hashCode ^
      kmf.hashCode ^
      krw.hashCode ^
      kwd.hashCode ^
      kyd.hashCode ^
      kzt.hashCode ^
      lak.hashCode ^
      lbp.hashCode ^
      lkr.hashCode ^
      lrd.hashCode ^
      lsl.hashCode ^
      lyd.hashCode ^
      mad.hashCode ^
      mdl.hashCode ^
      mga.hashCode ^
      mkd.hashCode ^
      mmk.hashCode ^
      mnt.hashCode ^
      mop.hashCode ^
      mru.hashCode ^
      mur.hashCode ^
      mvr.hashCode ^
      mwk.hashCode ^
      mxn.hashCode ^
      myr.hashCode ^
      mzn.hashCode ^
      nad.hashCode ^
      ngn.hashCode ^
      nio.hashCode ^
      nok.hashCode ^
      npr.hashCode ^
      nzd.hashCode ^
      omr.hashCode ^
      pab.hashCode ^
      pen.hashCode ^
      pgk.hashCode ^
      php.hashCode ^
      pkr.hashCode ^
      pln.hashCode ^
      pyg.hashCode ^
      qar.hashCode ^
      ron.hashCode ^
      rsd.hashCode ^
      rub.hashCode ^
      rwf.hashCode ^
      sar.hashCode ^
      sbd.hashCode ^
      scr.hashCode ^
      sdg.hashCode ^
      sek.hashCode ^
      sgd.hashCode ^
      shp.hashCode ^
      sle.hashCode ^
      sll.hashCode ^
      sos.hashCode ^
      srd.hashCode ^
      ssp.hashCode ^
      stn.hashCode ^
      syp.hashCode ^
      szl.hashCode ^
      thb.hashCode ^
      tjs.hashCode ^
      tmt.hashCode ^
      tnd.hashCode ^
      top.hashCode ^
      ttd.hashCode ^
      tvd.hashCode ^
      twd.hashCode ^
      tzs.hashCode ^
      uah.hashCode ^
      ugx.hashCode ^
      usd.hashCode ^
      uyu.hashCode ^
      uzs.hashCode ^
      ves.hashCode ^
      vnd.hashCode ^
      vuv.hashCode ^
      wst.hashCode ^
      xaf.hashCode ^
      xcd.hashCode ^
      xdr.hashCode ^
      xof.hashCode ^
      xpf.hashCode ^
      yer.hashCode ^
      zar.hashCode ^
      zmw.hashCode ^
      zwl.hashCode;
}
