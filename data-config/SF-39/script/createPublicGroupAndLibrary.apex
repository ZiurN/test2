// 1. Buscar las colas Front y CDC
List<Group> queues = [SELECT Id,
						Name,
						DeveloperName
					FROM Group
					WHERE Type = 'Queue'
						AND (DeveloperName = 'Front'
							OR DeveloperName = 'CDC')];
if (!queues.isEmpty()) {
// 2. Crear el grupo público para las colas
	Group publicGroup = new Group (
		Type = 'Regular',
		Name = 'Front Public Group',
		DeveloperName = 'Front_PG'
	);
	insert publicGroup;
// 3. Crear los miembros del grupo público a partir de los miembros de las colas
	List<GroupMember> groupMembersFromQueues = [SELECT UserOrGroupId, Group.DeveloperName FROM GroupMember WHERE GroupId IN: queues];
	List<GroupMember> groupMembersToInsert = new List<GroupMember>();
	for (GroupMember groupMemberFromQ : groupMembersFromQueues) {
		if (groupMemberFromQ.UserOrGroupId.getSObjectType().getDescribe().getName() == 'User') {
			GroupMember publicGroupMember = new GroupMember(
				UserOrGroupId = groupMemberFromQ.UserOrGroupId,
				GroupId = publicGroup.Id
			);
			groupMembersToInsert.add(publicGroupMember);
		}
	}
	insert groupMembersToInsert;
// 4. Crear la libreria para el grupo público
	ContentWorkspace groupLibrary = new ContentWorkspace(
		Description = 'Libreria Front',
		Name = 'Front Public Group Library',
		DeveloperName = 'Front_PG_Library'
	);
	insert groupLibrary;
// 5. Crear el permiso para la librería
	ContentWorkspacePermission libraryPermission = new ContentWorkspacePermission(
		Name = 'Standard Permission',
		PermissionsAddComment = true,
		PermissionsAddContent = true,
		PermissionsAddContentOBO = true,
		PermissionsArchiveContent = true,
		PermissionsChatterSharing = true,
		PermissionsContentPackEnabled = true,
		PermissionsDeleteContent = true,
		PermissionsDeliverContent = true,
		PermissionsFeatureContent = true,
		PermissionsOrganizeFileAndFolder = true,
		PermissionsTagContent= true,
		PermissionsViewComments = true,
		PermissionsManageWorkspace = true
	);
	insert libraryPermission;
// 6. Crear el miembro de la libreria para el grupo público
	List<ContentWorkspaceMember> librariesMembersToCreate = new List<ContentWorkspaceMember>();
	ContentWorkspaceMember publicGroupMember = new ContentWorkspaceMember (
		ContentWorkspaceId = groupLibrary.Id,
		ContentWorkspacePermissionId = libraryPermission.Id,
		MemberId = publicGroup.Id
	);
	librariesMembersToCreate.add(publicGroupMember);
// 7. Crear los miembros de la libreria para los usuarios platint
	List<User> plaTints = [SELECT Id FROM User WHERE isActive = true AND Alias = 'platint'];
	for (User plaTint : plaTints) {
		ContentWorkspaceMember member = new ContentWorkspaceMember(
			ContentWorkspaceId = groupLibrary.Id,
			ContentWorkspacePermissionId = libraryPermission.Id,
			MemberId = plaTint.Id
		);
		librariesMembersToCreate.add(member);
	}
	Database.insert(librariesMembersToCreate, false);
}