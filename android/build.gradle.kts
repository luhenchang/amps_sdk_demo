allprojects {
    repositories {
        google()
        mavenCentral()
        maven {//TODO 媒体依赖需要添加
            name = "myrepo"
            url = uri("file:///D:/wangfei/soft/flutter_windows/PUB/hosted/pub.dev/amps_sdk-0.0.5/android/m2repository")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
