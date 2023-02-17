import _ from 'lodash';
import getReplacedIndex from './get_replaced_index';

export default function modifyPayload(server) {
  const config = server.config();

  return function (request) {

    let req = request.raw.req;
    return new Promise(function (fulfill, reject) {

      let body = '';

      // Accumulate requested chunks
      req.on('data', function (chunk) {
        body += chunk;
      });

      req.on('end', function () {
        fulfill({
          payload: replaceRequestBody(body)
        });
      });

    });

    // Replace kibana.index in mget request body
    function replaceRequestBody(body) {


// my 添加二级排序，使用字段offset 【开始】
 
     try{
      if (request.path === '/_msearch'){
        let lines = body.split('\n');
        for(var i = 0; i < lines.length; i++){
          if(lines[i].length > 2){
                var tmp = JSON.parse(lines[i]);
                if( typeof(tmp) == "object"
                        && tmp.hasOwnProperty("sort") && tmp["sort"].length == 1
                        && typeof(tmp["sort"][0]) == "object" && tmp["sort"][0].hasOwnProperty("@timestamp")
                        && tmp["sort"][0]["@timestamp"]["order"] == "desc" ){
 
                        server.log(['plugin:own-home', 'debug'], '################ request.path: ' + i + '  : '+ lines[i]);
                        var offsetSort = JSON.parse("{\"offset\":{\"order\":\"desc\",\"unmapped_type\":\"boolean\"}}");
                        tmp["sort"][1] = offsetSort;
 
                        lines[i] = JSON.stringify(tmp);
                        body = lines.join("\n");
                        server.log(['plugin:own-home', 'debug'], '################ request.path: ' + body);
                }
          }
 
        }
      }
     } catch(err){
        server.log(['plugin:own-home', 'debug'], 'body add sort fail ' + body + '    : ' + err);
     }
// my 添加二级排序，使用字段offset 【结束】



      if (!request.path.endsWith('_mget')) {
        return new Buffer(body);
      }
      try {
        if (!body) {
          return new Buffer(body);
        }
        let data = JSON.parse(body);
        let payload = '';
        if ('docs' in data) {
          let replaced = false;
          let i = 0;
          data['docs'] = _.map(data['docs'], function (doc) {
            if ('_index' in doc && doc['_index'] == config.get('kibana.index')) {
              const replacedIndex = getReplacedIndex(server, request);
              if (replacedIndex) {
                doc['_index'] = replacedIndex;
                replaced = true;
                server.log(['plugin:own-home', 'debug'], 'Replace docs[' + i + '][\'_index\'] "' + config.get('kibana.index') + '" with "' + replacedIndex + '"');
                if (!('_id' in doc)) {
                  doc['_id'] = '.kibana-devnull';
                  server.log(['plugin:own-home', 'debug'], 'Missing docs[' + i + '][\'_id\']: Put .kibana-devnull');
                }
              }
            }
            i++;
            return doc;
          });
          payload = JSON.stringify(data);
          if (replaced) {
            server.log(['plugin:own-home', 'debug'], 'Original request payload: ' + JSON.stringify(JSON.parse(body)));
            server.log(['plugin:own-home', 'debug'], 'Replaced request payload: ' + payload);
          }
        }
        return new Buffer(payload);
      } catch (err) {
        server.log(['plugin:own-home', 'error'], 'Bad JSON format: ' + body + ': ' + err);
        return new Buffer(body);
      }
    }

  };
};
