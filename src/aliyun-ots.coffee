fs = require 'fs'
path = require 'path'

requestFn = require 'request'
utility = require 'utility'
whenjs = require 'when'
nodefn = require 'when/node'
bindCallback = nodefn.bindCallback
SchemaProtobuf = require('protobuf').Schema
request = nodefn.lift requestFn


schemaProtobuf = new SchemaProtobuf fs.readFileSync './ots_protocol.desc'


ErrorMessage = schemaProtobuf['com.aliyun.cloudservice.ots2.Error']

CreateTableRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.CreateTableRequest']
CreateTableResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.CreateTableResponse']

UpdateTableRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.UpdateTableRequest']
UpdateTableResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.UpdateTableResponse']
DescribeTableRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.DescribeTableRequest']
DescribeTableResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.DescribeTableResponse']
ListTableResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.ListTableResponse']
DeleteTableRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.DeleteTableRequest']
CreateTableResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.CreateTableResponse ']


GetRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.GetRowRequest']
GetRowResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.GetRowResponse']
ColumnUpdate = schemaProtobuf['com.aliyun.cloudservice.ots2.ColumnUpdate']
UpdateRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.UpdateRowRequest']
UpdateRowResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.UpdateRowResponse']
PutRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.PutRowRequest']
PutRowResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.PutRowResponse']
DeleteRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.DeleteRowRequest']
DeleteRowResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.DeleteRowResponse']


RowInBatchGetRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.RowInBatchGetRowRequest']
TableInBatchGetRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.TableInBatchGetRowRequest']
BatchGetRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.BatchGetRowRequest']
RowInBatchGetRowResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.RowInBatchGetRowResponse']
TableInBatchGetRowResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.TableInBatchGetRowResponse']
BatchGetRowResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.BatchGetRowResponse']
PutRowInBatchWriteRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.PutRowInBatchWriteRowRequest']
UpdateRowInBatchWriteRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.UpdateRowInBatchWriteRowRequest']
DeleteRowInBatchWriteRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.DeleteRowInBatchWriteRowRequest']
TableInBatchWriteRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.TableInBatchWriteRowRequest']
BatchWriteRowRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.BatchWriteRowRequest']
RowInBatchWriteRowResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.RowInBatchWriteRowResponse']
TableInBatchWriteRowResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.TableInBatchWriteRowResponse']
BatchWriteRowResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.BatchWriteRowResponse']


GetRangeRequest = schemaProtobuf['com.aliyun.cloudservice.ots2.GetRangeRequest']
GetRangeResponse = schemaProtobuf['com.aliyun.cloudservice.ots2.GetRangeResponse']


ResponseMap =

  CreateTable: CreateTableResponse
  GetRow: GetRowResponse
  PutRow: PutRowResponse
  UpdateRow: UpdateRowResponse
  DeleteRow: DeleteRowResponse
  GetRange: GetRangeResponse
  BatchGetRow: BatchGetRowResponse
  BatchWriteRow: BatchWriteRowResponse
  ListTable: ListTableResponse
  UpdateTable: UpdateTableResponse
  DescribeTable: DescribeTableResponse


Client = (options)->
  @accessKeyID = options.accessKeyID
  @accessKeySecret = options.accessKeySecret
  @APIVersion = options.APIVersion || '2014-08-08'
  @instanceName = options.instanceName
  @region = options.region
  @protocol = options.protocol || 'http'

  if options.internal
    @APIHost = "#{@protocol}://#{@instanceName}.#{@region}.ots-internal.aliyuncs.com"
  else
    @APIHost = "#{@protocol}://#{@instanceName}.#{@region}.ots.aliyuncs.com"

  @requestAgent = options.agent || null
  @requestTimeout = options.requestTimeout || 5000
  return


exports = module.exports = Client

Client::createTable = (name, primaryKeys, capacityUnit, cb)->
  params =
    tableMeta:
      tableName: name
      primaryKey: primaryKeys
    reservedThroughput:
      capacityUnit: capacityUnit

  body = CreateTableRequest.serialize params
  requestResult = @request 'CreateTable', body
  bindCallback requestResult, cb


Client::updateTable = (name, capacityUnit, cb)->
  params =
    tableName: name
    reservedThroughput:
      capacityUnit: capacityUnit
  body = UpdateTableRequest.serialize params
  requestResult = @request 'UpdateTable', body
  bindCallback requestResult, cb


Client::describeTable = (name, cb)->
  params =
    tableName: name

  body = DescribeTableRequest.serialize params
  requestResult = @request 'DescribeTable', body
  bindCallback requestResult, cb


Client::listTable = (cb)->
  requestResult = @request 'ListTable', ''
  bindCallback requestResult, cb


Client::deleteTable = (name, cb)->
  params =
    tableName: name
  body = DeleteTableRequest.serialize params
  requestResult = @request 'DeleteTable', body
  bindCallback requestResult, cb


Client::getRow = (name, primaryColumns, columnsToGet, cb)->
  params =
    tableName: name
    primaryKey: primaryColumns
    columnsToGet: columnsToGet
  body = GetRowRequest.serialize params
  requestResult = @request 'GetRow', body
  bindCallback requestResult, cb


Client::putRow = (tableName, condition, primaryColumns, attributeColumns, cb)->
  params =
    tableName: tableName
    condition:
      rowExistence: condition
    primaryKey: primaryColumns
    attributeColumns: attributeColumns
  body = PutRowRequest.serialize params
  requestResult = @request 'PutRow', body
  bindCallback requestResult, cb


Client::updateRow = (tableName, condition, primaryColumns, attributeColumns, cb)->
  params =
    tableName: tableName
    condition:
      rowExistence: condition
    primaryKey: primaryColumns
    attributeColumns: attributeColumns
  body = UpdateRowRequest.serialize params
  requestResult = @request 'UpdateRow', body
  bindCallback requestResult, cb


Client::deleteRow = (tableName, condition, primaryColumns, cb)->
  params =
    tableName: tableName
    condition:
      rowExistence: condition
    primaryKey: primaryColumns
  body = DeleteRowRequest.serialize params
  requestResult = @request 'DeleteRow', body
  bindCallback requestResult, cb


Client::batchGetRow = (tables, cb)->
  params =
    tables: tables
  body = BatchGetRowRequest.serialize params
  requestResult = @request 'BatchGetRow', body
  bindCallback requestResult, cb


Client::batchWriteRow = (tables, cb)->
  params =
    tables: tables
  body = BatchWriteRowRequest.serialize params
  requestResult = @request 'BatchWriteRow', body
  bindCallback requestResult, cb


Client::getRange = (tableName, direction, columnsToGet, limit, inclusiveStartPrimaryKey, exclusiveEndPrimaryKey, cb)->
  params =
    tableName: tableName
    direction: 'FORWARD'
    columnsToGet: columnsToGet
    limit: limit
    inclusiveStartPrimaryKey: inclusiveStartPrimaryKey
    exclusiveEndPrimaryKey: exclusiveEndPrimaryKey
  body = GetRangeRequest.serialize params
  requestResult = @request 'GetRange', body
  bindCallback requestResult, cb


Client::request = (opAction, body)->
  canonicalURI = '/' + opAction
  self = @
  body ?= ''
  hostname = @APIHost
  headers = self._make_headers body, canonicalURI
  url = hostname + canonicalURI
  err = {}

  request
    url: url
    method: 'POST'
    headers: headers
    body: body
    json: false
    encoding: null
  .then ([res, body])->
    statusCode = res.statusCode
    if !self._check_response_sign res, canonicalURI
      throw 'WrongResponseSign'
    if statusCode != 200
      err = new Error 'requestError'
      err.name = 'requestError'
      err.code = statusCode
      try
        err.info = ErrorMessage.parse body
      catch  e
        err.info = 'MalformedError'
      try
        err.body = body.toString()
      catch
        err.body = null
      throw err


    protoResponse = ResponseMap[opAction]
    if !protoResponse
      return [null, res]

    try
      result = protoResponse.parse res.body
    catch e
      err = new Error 'malFormaedBuf'
      err.body = body.toString()
      err.info = e.message
      throw err

    return [result, res]


Client::_check_response_sign = (res, canonicalURI)->
  headers = res.headers || {}
  otsDate = new Date(headers['x-ots-date']).getTime()
  authorizationReturn = headers.authorization || ''
  sorted = []
  for key,value of headers
    if key.search('x-ots-') == 0
      sorted.push "#{key.toLowerCase().trim()}:#{value.trim()}"
  sorted.sort()
  stringToSign = "#{sorted.join('\n')}\n#{canonicalURI}"
  hmacStringToSign = utility.hmac 'sha1', @accessKeySecret, stringToSign
  authorization = "OTS #{@accessKeyID}:#{hmacStringToSign}"
  return authorization == authorizationReturn and (otsDate + 1000 * 60 * 15) > new Date().getTime()


Client::_make_headers = (body, canonicalURI)->
  bodyMD5 = utility.md5 body, 'base64'
  headers =
    'x-ots-date': new Date().toGMTString()
    'x-ots-apiversion': String @APIVersion
    'x-ots-accesskeyid': @accessKeyID
    'x-ots-instancename': @instanceName
    'x-ots-contentmd5': bodyMD5
  sorted = []
  for key,value of headers
    sorted.push "#{key}:#{value.trim()}"
  sorted.sort()
  stringToSign = "#{canonicalURI}\nPOST\n\n#{sorted.join('\n')}\n"
  headers['x-ots-signature'] = utility.hmac 'sha1', @accessKeySecret, stringToSign, 'base64'

  return headers

module.exports.createClient = (options)->
  new Client options