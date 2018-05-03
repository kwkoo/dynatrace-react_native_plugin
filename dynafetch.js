/**
 * A fetch() wrapper that wraps fetch calls in a user action. This gives us
 * visibility of web requests made using fetch().
 *
 * A better workaround would be to install an okhttp3 interceptor.
 * Unfortunately a recent change in the NetworkingModule broke the ability
 * to add custom interceptors. A workaround is documented here:
 * https://github.com/facebook/react-native/issues/13487#issuecomment-319984503
 *
 * However, the workaround may break with future revisions to the framework.
 */

module.exports = async function dynafetch(url) {
  var action = global.dt.enterAction('WebRequest(' + url + ')');
  try {
    let response = await fetch(url);
    return response;
  }
  catch (error) {
    global.dt.reportErrorInAction(action, error.message, 100);
    throw error;
  } finally {
    global.dt.leaveAction(action);
  }
}
