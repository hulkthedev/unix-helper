<?php

use Arvato\WishlistService\Kernel;
use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Symfony\Component\DependencyInjection\Container;
use Symfony\Component\Dotenv\Exception\FormatException;
use Symfony\Component\Dotenv\Exception\PathException;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * @author      Alexej Beirith <alexej.beirith@arvato.com>
 * @copyright   2019, arvato eCommerce mbH
 */
class BehatContext implements Context
{
    /** @var Container */
    private $container;

    /** @var string */
    private $baseUrl;

    /** @var array */
    private $params = [];

    /** @var Kernel */
    private $kernel;

    /** @var Response */
    private $response;

    /**
     * @throws Exception
     */
    public function __construct()
    {
        $_SERVER['DOCUMENT_ROOT'] = __DIR__ . '/../../public';

        $this->initContainer();

        if (getenv('ENV') === 'dev') {
            $_SERVER['HTTP_HOST'] = 'dev.esprit.de';
        } else {
            $_SERVER['HTTP_HOST'] = '127.0.0.1';
        }

        $this->baseUrl = getenv('ENV') === 'dev'
            ? 'http://dev.esprit.de/services/wishlistservice'
            : 'http://' . $_SERVER['HTTP_HOST'];

        $_SERVER['HTTP_X_FORWARDED_HOST'] = 'www.esprit.de';
    }

    /**
     * @throws FormatException
     * @throws RuntimeException
     * @throws PathException
     */
    private function initContainer(): void
    {
        if (!isset($_SERVER['APP_ENV'])) {
            if (!class_exists(\Symfony\Component\Dotenv\Dotenv::class)) {
                throw new RuntimeException('APP_ENV environment variable is not defined.');
            }

            (new \Symfony\Component\Dotenv\Dotenv())->load(__DIR__ . '/../../.env');
        }

        $env = $_SERVER['APP_ENV'] ?? 'dev';
        $debug = (bool)($_SERVER['APP_DEBUG'] ?? ('prod' !== $env));

        if ($debug) {
            umask(0000);
            \Symfony\Component\Debug\Debug::enable();
        }

        $this->kernel = new Kernel($env, $debug);
        $this->kernel->boot();

        $this->container = $this->kernel->getContainer();
    }

    /**
     * @Given /^I call the REST API with Method "([^"]*)", Locale "([^"]*)" and URI "([^"]*)"$/
     * @param string $method
     * @param string $locale
     * @param string $uri
     * @throws Exception
     */
    public function iCallTheRESTAPIWithMethodAndLocaleAndURI(string $method, string $locale, string $uri): void
    {
        if ($locale !== '') {
            $uri .= "/$locale";
        }

        $request = Request::create($uri, $method, $this->params);
        $request->headers->set('CONTENT_TYPE', 'application/json');

        $this->response = $this->kernel->handle($request);
    }

    /**
     * @Given /^I call the REST API with Method "([^"]*)" and URI "([^"]*)"$/
     * @param string $method
     * @param string $uri
     * @throws Exception
     */
    public function iCallTheRESTAPIWithMethodAndURI(string $method, string $uri): void
    {
        $jsonParams = null;
        if (count($this->params) > 0) {
            $jsonParams = json_encode($this->params);
        }

        $request = Request::create($uri, $method, $this->params, [], [], [], $jsonParams);
        $request->headers->set('CONTENT_TYPE', 'application/json');

        $this->response = $this->kernel->handle($request);
    }

    /**
     * @Given /^I set request parameter "([^"]*)" with "([^"]*)"$/
     * @param string $key
     * @param array|string $value
     */
    public function iSetRequestParameterWith(string $key, $value): void
    {
        $this->params[$key] = $value;
    }

    /**
     * @Then /^I should see a json response:$/
     * @param PyStringNode $expectedResponseContent
     * @throws Exception
     */
    public function iShouldSeeAJsonResponse(PyStringNode $expectedResponseContent): void
    {
        $rawExpectedContent = $expectedResponseContent->getRaw();
        $expectedAsArray = json_decode($rawExpectedContent, true);

        if ($expectedAsArray === null && $rawExpectedContent !== null) {
            throw new Exception('Input is no valid json!');
        }

        $responseAsArray = json_decode($this->response->getContent(), true);

        if ($responseAsArray != $expectedAsArray) {
            $exceptionMessage = sprintf(
                'Expected:%s%s%sActual:%s%s%s',
                PHP_EOL,
                json_encode($expectedAsArray),
                PHP_EOL,
                PHP_EOL,
                json_encode($responseAsArray),
                PHP_EOL
            );

            throw new Exception($exceptionMessage);
        }
    }
}