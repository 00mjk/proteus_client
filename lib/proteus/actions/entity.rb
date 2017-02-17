module Proteus
  module Actions
    module Entity
      # get parent entity
      # <message name="ProteusAPI_getParent">
      #   <part name="entityId" type="xsd:long"/>
      # </message>
      def get_parent(id = nil)
        Proteus::ApiEntity.new call(:get_parent, entityId: id || @view_id)
      end

      # get top level configurations
      # <message name="ProteusAPI_getEntities">
      #   <part name="parentId" type="xsd:long"/>
      #   <part name="type" type="xsd:string"/>
      #   <part name="start" type="xsd:int"/>
      #   <part name="count" type="xsd:int"/>
      # </message>
      def get_entities(parent_id = 0, type = Proteus::Types::CONFIGURATION, start = 0, count = 10)
        response = call(:get_entities, parentId: parent_id, type: type, start: start, count: count)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end

      # deletes an object by id
      # <message name="ProteusAPI_delete">
      #   <part name="objectId" type="xsd:long"/>
      # </message>
      def delete(id)
        entity = get_entity_by_id(id)
        if ALLOWDELETE.include?(entity.type)
          call(:delete, object_id: id)
        else
          msg = 'Not allowed to delete entity with type: ' + entity.type
          raise Proteus::ApiEntityError::ActionNotAllowed, msg
        end
      end

      # get entity by id
      # <message name="ProteusAPI_getEntityById">
      #   <part name="id" type="xsd:long"/>
      # </message>
      def get_entity_by_id(id = nil)
        Proteus::ApiEntity.new call(:get_entity_by_id, id: id || @view_id)
      end

      # get entity by name
      # <message name="ProteusAPI_getEntityById">
      #   <part name="id" type="xsd:long"/>
      # </message>
      def get_entity_by_name(parent_id = 0, name, type)
        parent_id ||= @view_id
        Proteus::ApiEntity.new call(:get_entity_by_name, parentId: parent_id, name: name, type: type)
      end

      # get entity by CIDR
      # <message name="ProteusAPI_getEntityByCIDR">
      #   <part name="parentId" type="xsd:long"/>
      #   <part name="cidr" type="xsd:string"/>
      #   <part name="type" type="xsd:string"/>
      # </message>
      def get_entity_by_cidr(parent_id = 0, cidr = '0.0.0.0/0', type = Proteus::Types::IP4NETWORK)
        parent_id ||= @view_id
        Proteus::ApiEntity.new call(:get_entity_by_cidr, parentId: parent_id, CIDR: cidr, type: type)
      end

      # get entity by Range
      # <message name="ProteusAPI_getEntityByCIDR">
      #   <part name="parentId" type="xsd:long"/>
      #   <part name="cidr" type="xsd:string"/>
      #   <part name="type" type="xsd:string"/>
      # </message>
      def get_entity_by_range(parent_id = 0, addr1 = '0.0.0.0', addr2 = '0.0.0.0', type = Proteus::Types::IP4NETWORK)
        parent_id ||= @view_id
        Proteus::ApiEntity.new call(:get_entity_by_range, parentId: parent_id, address1: addr1, address2: addr2, type: type)
      end

      # search by categories
      # <message name="ProteusAPI_searchByCategory">
      #   <part name="keyword" type="xsd:string"/>
      #   <part name="category" type="xsd:string"/>
      #   <part name="start" type="xsd:int"/>
      #   <part name="count" type="xsd:int"/>
      # </message>
      def search_by_category(keyword, category = 'ALL', start = 0, count = 10)
        response = call(:search_by_category, keyword: keyword, category: category, start: start, count: count)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end

      # search by object types
      # <message name="ProteusAPI_searchByObjectTypes">
      #   <part name="keyword" type="xsd:string"/>
      #   <part name="types" type="xsd:string"/>
      #   <part name="start" type="xsd:int"/>
      #   <part name="count" type="xsd:int"/>
      # </message>
      def search_by_object_types(keyword, types = Proteus::Types::GENERICRECORD, start = 0, count = 10)
        response = call(:search_by_object_types, keyword: keyword, types: types, start: start, count: count)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end
    end
  end
end