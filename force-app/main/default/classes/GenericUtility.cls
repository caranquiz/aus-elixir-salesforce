/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : GenericUtility */
/* Created Date         : 20/07/2020 */
/* Developed By         : Rameswari Barman */
/* Description          : This class contains some common methods to use. */
/* Last Modified Date   : 20/07/2020 */
/* Last Modified By     : Rameswari Barman */
/****************************************************************************************************/
public with sharing class GenericUtility {
  /*** This method is used to insert logs, for debug purpose ***/
  public static void insertLog(String name, Exception ex) {
    Database.insert(
      new clcommon__Log__c(
        Name = name,
        clcommon__Message__c = name +
          '|::Exception occured in::' +
          ex.getStackTraceString() +
          '|::Error::' +
          ex.getMessage() +
          ' at Line Number::' +
          ex.getLineNumber(),
        clcommon__Time__c = System.Now()
      )
    );
  }
  // This method is used to insert batch process logs, for debug purpose
  public static void insertBatchProcessLog(String name, Exception ex) {
    Database.insert(
      new Loan__Batch_Process_log__c(
        loan__Message__c = name +
          '|::Exception occured in::' +
          ex.getStackTraceString() +
          '|::Error::' +
          ex.getMessage() +
          ' at Line Number::' +
          ex.getLineNumber(),
        loan__Time__c = System.Now(),
        loan__Log_Level__c = 'ERROR'
      )
    );
  }
  public static String modifyJsonKeysIntoCamelcasing(String json){
    json = json.replaceAll(
    'NodeValue',
    'nodeValue'
    );
    json = json.replaceAll(
    'Envelope',
    'envelope'
    );
    json = json.replaceAll(
    'Body',
    'body'
    );
    json = json.replaceAll(
    ConstantValues.HS_LANDTITLE,
    ConstantValues.US_LANDTITLE
    );
    json = json.replaceAll(
    ConstantValues.HS_TITLE,
    ConstantValues.US_TITLE
    );
    json = json.replaceAll(
    ConstantValues.HS_HEADER,
    ConstantValues.US_HEADER
    );
    json = json.replaceAll(
    ConstantValues.HS_RESPONSE,
    ConstantValues.US_RESPONSE
    );
    json = json.replaceAll(
    ConstantValues.HS_DATA,
    ConstantValues.US_DATA
    );
    json = json.replaceAll(
    ConstantValues.HS_PAID,
    ConstantValues.US_PAID
    );
    json = json.replaceAll(
    ConstantValues.HS_TERRITORY,
    ConstantValues.US_TERRITORY
    );
    json = json.replaceAll(
    ConstantValues.HS_LAND,
    ConstantValues.US_LAND
    );
    json = json.replaceAll(
    ConstantValues.HS_REGISTRY,
    ConstantValues.US_REGISTRY
    );
    json = json.replaceAll(
    ConstantValues.HS_REFERENCE,
    ConstantValues.US_REFERENCE
    );
    json = json.replaceAll(
    ConstantValues.HS_DESCRIPTION,
    ConstantValues.US_DESCRIPTION
    );
    json = json.replaceAll(
    ConstantValues.HS_PRICE,
    ConstantValues.US_PRICE
    );
    json = json.replaceAll(
    ConstantValues.HS_VALUE,
    ConstantValues.US_VALUE
    );
    json = json.replaceAll(
    ConstantValues.HS_DETAIL,
    ConstantValues.US_DETAIL
    );
    json = json.replaceAll(
    ConstantValues.HS_DOCUMENT,
    ConstantValues.US_DOCUMENT
    );
    json = json.replaceAll(
    ConstantValues.HS_DATA,
    ConstantValues.US_DATA
    );
    json = json.replaceAll(
    ConstantValues.HS_ID,
    ConstantValues.US_ID
    );
    json = json.replaceAll(
    ConstantValues.HS_STATUS,
    ConstantValues.US_STATUS
    );
    json = json.replaceAll(
    ConstantValues.HS_TIME,
    ConstantValues.US_TIME
    );
    return json;
  }
  public static String convert2StreetTypeCode(String streetType) {
    String res = '';
    String code;
    streetType = streetType.trim().toUppercase();
    Map<String, String> streetTypeCodeMap = new Map<String, String>();
    code = 'ACCS';
    streetTypeCodeMap.put('ACCESS', code);
    code = 'ALLY';
    streetTypeCodeMap.put('ALLEY', code);
    code = 'ALWY';
    streetTypeCodeMap.put('ALLEYWAY', code);
    code = 'AMBL';
    streetTypeCodeMap.put('AMBLE', code);
    code = 'ANCG';
    streetTypeCodeMap.put('ANCHORAGE', code);
    code = 'APP';
    streetTypeCodeMap.put('APPROACH', code);
    code = 'ARC';
    streetTypeCodeMap.put('ARCADE', code);
    code = 'ART';
    streetTypeCodeMap.put('ARTERY', code);
    code = 'AVE';
    streetTypeCodeMap.put('AVENUE', code);
    code = 'BASN';
    streetTypeCodeMap.put('BASIN', code);
    code = 'BCH';
    streetTypeCodeMap.put('BEACH', code);
    code = 'BEND';
    streetTypeCodeMap.put('BEND', code);
    code = 'BLK';
    streetTypeCodeMap.put('BLOCK', code);
    code = 'BVD';
    streetTypeCodeMap.put('BOULEVARD', code);
    code = 'BRCE';
    streetTypeCodeMap.put('BRACE', code);
    code = 'BRAE';
    streetTypeCodeMap.put('BRAE', code);
    code = 'BRK';
    streetTypeCodeMap.put('BREAK', code);
    code = 'BDGE';
    streetTypeCodeMap.put('BRIDGE', code);
    code = 'BDWY';
    streetTypeCodeMap.put('BROADWAY', code);
    code = 'BROW';
    streetTypeCodeMap.put('BROW', code);
    code = 'BYPA';
    streetTypeCodeMap.put('BYPASS', code);
    code = 'BYWY';
    streetTypeCodeMap.put('BYWAY', code);
    code = 'CAUS';
    streetTypeCodeMap.put('CAUSEWAY', code);
    code = 'CTR';
    streetTypeCodeMap.put('CENTRE', code);
    code = 'CNWY';
    streetTypeCodeMap.put('CENTREWAY', code);
    code = 'CH';
    streetTypeCodeMap.put('CHASE', code);
    code = 'CIR';
    streetTypeCodeMap.put('CIRCLE', code);
    code = 'CLT';
    streetTypeCodeMap.put('CIRCLET', code);
    code = 'CCT';
    streetTypeCodeMap.put('CIRCUIT', code);
    code = 'CRCS';
    streetTypeCodeMap.put('CIRCUS', code);
    code = 'CL';
    streetTypeCodeMap.put('CLOSE', code);
    code = 'CLDE';
    streetTypeCodeMap.put('COLONNADE', code);
    code = 'CMMN';
    streetTypeCodeMap.put('COMMON', code);
    code = 'CON';
    streetTypeCodeMap.put('CONCOURSE', code);
    code = 'CPS';
    streetTypeCodeMap.put('COPSE', code);
    code = 'CNR';
    streetTypeCodeMap.put('CORNER', code);
    code = 'CSO';
    streetTypeCodeMap.put('CORSO', code);
    code = 'CT';
    streetTypeCodeMap.put('COURT', code);
    code = 'CTYD';
    streetTypeCodeMap.put('COURTYARD', code);
    code = 'COVE';
    streetTypeCodeMap.put('COVE', code);
    code = 'CRST';
    streetTypeCodeMap.put('CRESCENT', code);
    code = 'CRES';
    streetTypeCodeMap.put('CREST', code);
    code = 'CRSS';
    streetTypeCodeMap.put('CROSS', code);
    code = 'CRSG';
    streetTypeCodeMap.put('CROSSING', code);
    code = 'CRD';
    streetTypeCodeMap.put('CROSSROAD', code);
    code = 'COWY';
    streetTypeCodeMap.put('CROSSWAY', code);
    code = 'CUWY';
    streetTypeCodeMap.put('CRUISEWAY', code);
    code = 'CDS';
    streetTypeCodeMap.put('CUL-DE-SAC', code);
    code = 'CTTG';
    streetTypeCodeMap.put('CUTTING', code);
    code = 'DALE';
    streetTypeCodeMap.put('DALE', code);
    code = 'DELL';
    streetTypeCodeMap.put('DELL', code);
    code = 'DEVN';
    streetTypeCodeMap.put('DEVIATION', code);
    code = 'DIP';
    streetTypeCodeMap.put('DIP', code);
    code = 'DSTR';
    streetTypeCodeMap.put('DISTRIBUTOR', code);
    code = 'DR';
    streetTypeCodeMap.put('DRIVE', code);
    code = 'DRWY';
    streetTypeCodeMap.put('DRIVEWAY', code);
    code = 'EDGE';
    streetTypeCodeMap.put('EDGE', code);
    code = 'ELB';
    streetTypeCodeMap.put('ELBOW', code);
    code = 'END';
    streetTypeCodeMap.put('END', code);
    code = 'ENT';
    streetTypeCodeMap.put('ENTRANCE', code);
    code = 'ESP';
    streetTypeCodeMap.put('ESPLANADE', code);
    code = 'EST';
    streetTypeCodeMap.put('ESTATE', code);
    code = 'EXP';
    streetTypeCodeMap.put('EXPRESSWAY', code);
    code = 'EXTN';
    streetTypeCodeMap.put('EXTENSION', code);
    code = 'FAWY';
    streetTypeCodeMap.put('FAIRWAY', code);
    code = 'FTRK';
    streetTypeCodeMap.put('FIRE TRACK', code);
    code = 'FITR';
    streetTypeCodeMap.put('FIRETRAIL', code);
    code = 'FLAT';
    streetTypeCodeMap.put('FLAT', code);
    code = 'FOLW';
    streetTypeCodeMap.put('FOLLOW', code);
    code = 'FTWY';
    streetTypeCodeMap.put('FOOTWAY', code);
    code = 'FSHR';
    streetTypeCodeMap.put('FORESHORE', code);
    code = 'FORM';
    streetTypeCodeMap.put('FORMATION', code);
    code = 'FWY';
    streetTypeCodeMap.put('FREEWAY', code);
    code = 'FRNT';
    streetTypeCodeMap.put('FRONT', code);
    code = 'FRTG';
    streetTypeCodeMap.put('FRONTAGE', code);
    code = 'GAP';
    streetTypeCodeMap.put('GAP', code);
    code = 'GDN';
    streetTypeCodeMap.put('GARDEN', code);
    code = 'GTE';
    streetTypeCodeMap.put('GATE', code);
    code = 'GDNS';
    streetTypeCodeMap.put('GARDENS', code);
    code = 'GTES';
    streetTypeCodeMap.put('GATES', code);
    code = 'GLD';
    streetTypeCodeMap.put('GLADE', code);
    code = 'GLEN';
    streetTypeCodeMap.put('GLEN', code);
    code = 'GRA';
    streetTypeCodeMap.put('GRANGE', code);
    code = 'GRN';
    streetTypeCodeMap.put('GREEN', code);
    code = 'GRND';
    streetTypeCodeMap.put('GROUND', code);
    code = 'GR';
    streetTypeCodeMap.put('GROVE', code);
    code = 'GLY';
    streetTypeCodeMap.put('GULLY', code);
    code = 'HTS';
    streetTypeCodeMap.put('HEIGHTS', code);
    code = 'HRD';
    streetTypeCodeMap.put('HIGHROAD', code);
    code = 'HWY';
    streetTypeCodeMap.put('HIGHWAY', code);
    code = 'HILL';
    streetTypeCodeMap.put('HILL', code);
    code = 'INTG';
    streetTypeCodeMap.put('INTERCHANGE', code);
    code = 'INTN';
    streetTypeCodeMap.put('INTERSECTION', code);
    code = 'JNC';
    streetTypeCodeMap.put('JUNCTION', code);
    code = 'code';
    streetTypeCodeMap.put('code', code);
    code = 'LDG';
    streetTypeCodeMap.put('LANDING', code);
    code = 'LANE';
    streetTypeCodeMap.put('LANE', code);
    code = 'LNWY';
    streetTypeCodeMap.put('LANEWAY', code);
    code = 'LEES';
    streetTypeCodeMap.put('LEES', code);
    code = 'LINE';
    streetTypeCodeMap.put('LINE', code);
    code = 'LINK';
    streetTypeCodeMap.put('LINK', code);
    code = 'LT';
    streetTypeCodeMap.put('LITTLE', code);
    code = 'LKT';
    streetTypeCodeMap.put('LOOKOUT', code);
    code = 'LOOP';
    streetTypeCodeMap.put('LOOP', code);
    code = 'LWR';
    streetTypeCodeMap.put('LOWER', code);
    code = 'MALL';
    streetTypeCodeMap.put('MALL', code);
    code = 'MNDR';
    streetTypeCodeMap.put('MEANDER', code);
    code = 'MEW';
    streetTypeCodeMap.put('MEW', code);
    code = 'MEWS';
    streetTypeCodeMap.put('MEWS', code);
    code = 'MWY';
    streetTypeCodeMap.put('MOTORWAY', code);
    code = 'MT';
    streetTypeCodeMap.put('MOUNT', code);
    code = 'NOOK';
    streetTypeCodeMap.put('NOOK', code);
    code = 'OTLK';
    streetTypeCodeMap.put('OUTLOOK', code);
    code = 'PDE';
    streetTypeCodeMap.put('PARADE', code);
    code = 'PARK';
    streetTypeCodeMap.put('PARK', code);
    code = 'PKLD';
    streetTypeCodeMap.put('PARKLANDS', code);
    code = 'PKWY';
    streetTypeCodeMap.put('PARKWAY', code);
    code = 'PART';
    streetTypeCodeMap.put('PART', code);
    code = 'PASS';
    streetTypeCodeMap.put('PASS', code);
    code = 'PATH';
    streetTypeCodeMap.put('PATH', code);
    code = 'PHWY';
    streetTypeCodeMap.put('PATHWAY', code);
    code = 'PIAZ';
    streetTypeCodeMap.put('PIAZZA', code);
    code = 'PL';
    streetTypeCodeMap.put('PLACE', code);
    code = 'PLAT';
    streetTypeCodeMap.put('PLATEAU', code);
    code = 'PLZA';
    streetTypeCodeMap.put('PLAZA', code);
    code = 'PKT';
    streetTypeCodeMap.put('POCKET', code);
    code = 'PNT';
    streetTypeCodeMap.put('POINT', code);
    code = 'PORT';
    streetTypeCodeMap.put('PORT', code);
    code = 'PROM';
    streetTypeCodeMap.put('PROMENADE', code);
    code = 'QUAD';
    streetTypeCodeMap.put('QUAD', code);
    code = 'QDGL';
    streetTypeCodeMap.put('QUADRANGLE', code);
    code = 'QDRT';
    streetTypeCodeMap.put('QUADRANT', code);
    code = 'QY';
    streetTypeCodeMap.put('QUAY', code);
    code = 'QYS';
    streetTypeCodeMap.put('QUAYS', code);
    code = 'RMBL';
    streetTypeCodeMap.put('RAMBLE', code);
    code = 'RAMP';
    streetTypeCodeMap.put('RAMP', code);
    code = 'RNGE';
    streetTypeCodeMap.put('RANGE', code);
    code = 'RCH';
    streetTypeCodeMap.put('REACH', code);
    code = 'RES';
    streetTypeCodeMap.put('RESERVE', code);
    code = 'REST';
    streetTypeCodeMap.put('REST', code);
    code = 'RTT';
    streetTypeCodeMap.put('RETREAT', code);
    code = 'RIDE';
    streetTypeCodeMap.put('RIDE', code);
    code = 'RDGE';
    streetTypeCodeMap.put('RIDGE', code);
    code = 'RGWY';
    streetTypeCodeMap.put('RIDGEWAY', code);
    code = 'ROWY';
    streetTypeCodeMap.put('RIGHT OF WAY', code);
    code = 'RING';
    streetTypeCodeMap.put('RING', code);
    code = 'RISE';
    streetTypeCodeMap.put('RISE', code);
    code = 'RVR';
    streetTypeCodeMap.put('RIVER', code);
    code = 'RVWY';
    streetTypeCodeMap.put('RIVERWAY', code);
    code = 'RVRA';
    streetTypeCodeMap.put('RIVIERA', code);
    code = 'RD';
    streetTypeCodeMap.put('ROAD', code);
    code = 'RDS';
    streetTypeCodeMap.put('ROADS', code);
    code = 'RDSD';
    streetTypeCodeMap.put('ROADSIDE', code);
    code = 'RDWY';
    streetTypeCodeMap.put('ROADWAY', code);
    code = 'RNDE';
    streetTypeCodeMap.put('RONDE', code);
    code = 'RSBL';
    streetTypeCodeMap.put('ROSEBOWL', code);
    code = 'RTY';
    streetTypeCodeMap.put('ROTARY', code);
    code = 'RND';
    streetTypeCodeMap.put('ROUND', code);
    code = 'RTE';
    streetTypeCodeMap.put('ROUTE', code);
    code = 'ROW';
    streetTypeCodeMap.put('ROW', code);
    code = 'RUE';
    streetTypeCodeMap.put('RUE', code);
    code = 'RUN';
    streetTypeCodeMap.put('RUN', code);
    code = 'SWY';
    streetTypeCodeMap.put('SERVICE WAY', code);
    code = 'SDNG';
    streetTypeCodeMap.put('SIDING', code);
    code = 'SLPE';
    streetTypeCodeMap.put('SLOPE', code);
    code = 'SND';
    streetTypeCodeMap.put('SOUND', code);
    code = 'SPUR';
    streetTypeCodeMap.put('SPUR', code);
    code = 'SQ';
    streetTypeCodeMap.put('SQUARE', code);
    code = 'STRS';
    streetTypeCodeMap.put('STAIRS', code);
    code = 'SHWY';
    streetTypeCodeMap.put('STATE HIGHWAY', code);
    code = 'STPS';
    streetTypeCodeMap.put('STEPS', code);
    code = 'STRA';
    streetTypeCodeMap.put('STRAND', code);
    code = 'ST';
    streetTypeCodeMap.put('STREET', code);
    code = 'STRP';
    streetTypeCodeMap.put('STRIP', code);
    code = 'SBWY';
    streetTypeCodeMap.put('SUBWAY', code);
    code = 'TARN';
    streetTypeCodeMap.put('TARN', code);
    code = 'TCE';
    streetTypeCodeMap.put('TERRACE', code);
    code = 'THOR';
    streetTypeCodeMap.put('THOROUGHFARE', code);
    code = 'TLWY';
    streetTypeCodeMap.put('TOLLWAY', code);
    code = 'TOP';
    streetTypeCodeMap.put('TOP', code);
    code = 'TOR';
    streetTypeCodeMap.put('TOR', code);
    code = 'TWRS';
    streetTypeCodeMap.put('TOWERS', code);
    code = 'TRK';
    streetTypeCodeMap.put('TRACK', code);
    code = 'TRL';
    streetTypeCodeMap.put('TRAIL', code);
    code = 'TRLR';
    streetTypeCodeMap.put('TRAILER', code);
    code = 'TRI';
    streetTypeCodeMap.put('TRIANGLE', code);
    code = 'TKWY';
    streetTypeCodeMap.put('TRUNKWAY', code);
    code = 'TURN';
    streetTypeCodeMap.put('TURN', code);
    code = 'UPAS';
    streetTypeCodeMap.put('UNDERPASS', code);
    code = 'UPR';
    streetTypeCodeMap.put('UPPER', code);
    code = 'VALE';
    streetTypeCodeMap.put('VALE', code);
    code = 'VDCT';
    streetTypeCodeMap.put('VIADUCT', code);
    code = 'VIEW';
    streetTypeCodeMap.put('VIEW', code);
    code = 'VLLS';
    streetTypeCodeMap.put('VILLAS', code);
    code = 'VSTA';
    streetTypeCodeMap.put('VISTA', code);
    code = 'WADE';
    streetTypeCodeMap.put('WADE', code);
    code = 'WALK';
    streetTypeCodeMap.put('WALK', code);
    code = 'WKWY';
    streetTypeCodeMap.put('WALKWAY', code);
    code = 'WAY';
    streetTypeCodeMap.put('WAY', code);
    code = 'WHRF';
    streetTypeCodeMap.put('WHARF', code);
    code = 'WYND';
    streetTypeCodeMap.put('WYND', code);
    code = 'YARD';
    streetTypeCodeMap.put('YARD', code);
    if(streetTypeCodeMap.get(streetType) != null){
      return streetTypeCodeMap.get(streetType);
    }
    return streetType;
  }
  public static void isValid(String value,String msg){
    if(String.isBlank(value)){
      throw new CustomException(msg);
    }
  }
  public static void isListValid(List<Map<String, Object>> value, String msg){
    if(value.isEmpty()){
      throw new CustomException(msg);
    }
  }
}