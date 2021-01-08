import 'dart:core';

const String MARTIN_1     = "eaf2a815-8331-4767-824b-3c875a6aff2b";
const String MARTIN_2     = "480085f1-062f-41f1-8d24-b64a299c0a67";

const String CRIS_1       = "3e4087a4-8e6e-4d06-8970-7837021261d1";
const String CRIS_2       = "98517983-b729-4959-9d73-beb834b5a3fa";

const String WEI_TSANG_1  = "bcecae8d-3232-44c8-a567-81beb1a4e99f";
const String WEI_TSANG_2  = "3897d1f2-b3b0-42b8-9d8a-721bec0e9f1d";

const String HALIM_1      = "5d1374db-2872-492c-aca0-4d8a7de45871";
const String HALIM_2      = "652dc76c-f9eb-4a9b-ac13-a5b95104a454";

const String AARON_1      = "b7d82925-4940-4991-a5bd-67fdb147ef84";
const String AARON_2      = "6d1a261e-1561-4797-be8d-bdcc4d8f2ac0";

const String TERENCE_1    = "f9e54fc2-c0d6-4300-8b4a-eb5f02fe912b";

const String DAMITH_1     = "a440491b-0211-4a65-9429-080fbf432be5";
const String DAMITH_2     = "949cd4b9-75ba-4039-b36b-c71c3b695757";

const String BIMLESH_1    = "347050eb-6f65-4e51-a58b-e743be25dd0d";
const String BIMLESH_2    = "60123a64-2f1d-4942-9ca4-19b2afb1ab51";

const String ADI_YOGA_1   = "5d2c6bd4-2024-4ade-8845-07905276f864";
const String ADI_YOGA_2   = "300bdb0d-8158-417e-9225-43a9d648795b";

const String MARTIN_NAME = 'Martin henz';
const String CRISTINA_NAME = 'Cristina Carbunaru';
const String WEI_TSANG_NAME = 'Ooi Wei Tsang';
const String STEVEN_NAME = 'Steven Halim';
const String AARON_NAME = 'Aaron Tan';
const String TERENCE_NAME = 'Terence Sim';
const String DAMITH_NAME = 'Damith Chatura Rajapakse';
const String BIMLESH_NAME = 'Bimlesh Wadhwa';
const String ADI_NAME = 'Adi Yoga';

const List<String> PROF_NAMES = [ MARTIN_NAME, CRISTINA_NAME, WEI_TSANG_NAME,
  STEVEN_NAME, AARON_NAME, TERENCE_NAME,
  DAMITH_NAME, BIMLESH_NAME, ADI_NAME ];

String faceIdToName(String faceId) {
  switch (faceId) {
    case MARTIN_1:
    case MARTIN_2:
      {
        return MARTIN_NAME;
      }
      break;

    case CRIS_1:
    case CRIS_2:
      {
        return CRISTINA_NAME;
      }
      break;

    case WEI_TSANG_1:
    case WEI_TSANG_2:
      {
        return WEI_TSANG_NAME;
      }
      break;

    case HALIM_1:
    case HALIM_2:
      {
        return STEVEN_NAME;
      }
      break;

    case AARON_1:
    case AARON_2:
      {
        return AARON_NAME;
      }
      break;

    case TERENCE_1:
      {
        return TERENCE_NAME;
      }
      break;

    case DAMITH_1:
    case DAMITH_2:
      {
        return DAMITH_NAME;
      }
      break;

    case BIMLESH_1:
    case BIMLESH_2:
      {
        return BIMLESH_NAME;
      }
      break;

    case ADI_YOGA_1:
    case ADI_YOGA_2:
      {
        return ADI_NAME;
      }
      break;

    default:
      {
        return "Sean";
      }
      break;
  }
}
