Future<void> createUser(UserEntity user) async {
  try {
    await ref.read(createUserProvider).call(user);

    await ref.read(auditLogServiceProvider).log(
      action: 'CREATE',
      entity: 'user',
      entityId: user.id,
      before: {},
      after: {
        'role': user.role,
        'storeIds': user.storeIds,
        'isActive': user.isActive,
      },
    );

    await loadUsers();
  } catch (e) {
    state = UsersError(e.toString());
  }
}
