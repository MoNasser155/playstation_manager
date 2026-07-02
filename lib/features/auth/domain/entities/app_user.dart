class AppUser {
  final String id;
  final String email;
  final String machineId;
  final bool isActive;

  const AppUser({
    required this.id,
    required this.email,
    required this.machineId,
    required this.isActive,
  });

  AppUser copyWith({bool? isActive}) => AppUser(
        id: id,
        email: email,
        machineId: machineId,
        isActive: isActive ?? this.isActive,
      );
}
