List<ContentWorkspaceMember> cwMembers = [SELECT Id FROM ContentWorkspaceMember];
Database.delete(cwMembers, false);
List<ContentWorkspacePermission> permissions = [SELECT Id FROM ContentWorkspacePermission WHERE Name = 'Standard Permission'];
Database.delete(permissions, false);
List<ContentWorkspace> cw = [SELECT Id FROM ContentWorkspace];
Database.delete(cw, false);
List<Group> pGroups = [SELECT Id, developerName FROM Group WHERE Type = 'Regular' AND DeveloperName LIKE '%_PG'];
Database.delete(pGroups, false);